# frozen_string_literal: true

class Users::Events::EventAttachmentsController < Users::Events::BaseController
  respond_to :json

  before_action :find_attachement, only: %i(edit update destroy)

  def index
    @attachments = @event.attachments.order(position: :asc)
    render json: @attachments.to_json
    # render json: @attachments, eachSerializer: EventAttachmentSerializer
  end

  def create
    @attachment = @event.attachments.new(attachment_params)
    if @attachment.save
      render json: @attachment.to_json
      # render json: @attachment, serializer: EventAttachmentSerializer
    else
      # si pb de type de PJ -> message spécifique pour interrompre le process
      if @attachment.errors.keys.include?(:asset_content_type)
        render status: 424, json: 'Ce type de support ne peut être ajouté'
      else # pb sur des champs classiques, affichage standard des erreurs
        render status: 422, json: { errors: @attachment.errors.full_messages.uniq }
      end
    end
  end

  def edit
    render layout: false
  end

  def update
    if @attachment.update(attachment_params)
      render json: @attachment.to_json
    else
      render status: 422, json: { errors: @attachment.errors.full_messages }
    end
  end

  def destroy
    if @attachment.destroy
      render json: { id: params[:id] }
    else
      render status: :unprocessable_entity, json: { errors: @attachment.errors.full_messages }
    end
  end

  private # ----------------------------------------

  def attachment_params
    # params.require(:attachment_asset)
    params
      .fetch(:asset_event_attachment) { {}.with_indifferent_access } # peut être vide
      .permit :id,
              :asset,
              :title,
              :custom_file_name,
              :format_type,
              :assetable_id
  end

  def find_attachement
    @attachment = Asset::EventAttachment.find(params[:id])
  end
end
