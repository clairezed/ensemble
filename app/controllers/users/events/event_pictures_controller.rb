# frozen_string_literal: true

class Users::Events::EventPicturesController < Users::Events::BaseController
  respond_to :json

  before_action :find_picture, only: %i(edit update destroy)

  def index
    @pictures = @event.pictures.order(created_at: :asc)
    render json: @pictures.to_json
  end

  def create
    @picture = @event.pictures.new(picture_params)
    if @picture.save
      render json: @picture.to_json
    else
      # si pb de type de PJ -> message spécifique pour interrompre le process
      if @picture.errors.keys.include?(:asset_content_type)
        render status: 424, json: 'Ce type d\'image ne peut être ajouté'
      else # pb sur des champs classiques, affichage standard des erreurs
        render status: 422, json: { errors: @picture.errors.full_messages.uniq }
      end
    end
  end


  def destroy
    if @picture.destroy
      render json: { id: params[:id] }
    else
      render status: :unprocessable_entity, json: { errors: @picture.errors.full_messages }
    end
  end

  private # ----------------------------------------

  def picture_params
    # params.require(:picture_asset)
    params
      .fetch(:asset_event_picture) { {}.with_indifferent_access } # peut être vide
      .permit :id,
              :asset,
              :title,
              :custom_file_name,
              :format_type,
              :assetable_id
  end

  def find_picture
    @picture = Asset::EventPicture.find(params[:id])
  end
end
