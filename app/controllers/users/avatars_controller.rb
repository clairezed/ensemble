class Users::AvatarsController < Users::BaseController
  respond_to :json

  skip_before_action :check_registration_uncomplete
  before_action :find_or_initialize_avatar, only: %i(create destroy)


  # Actions ====================================================================

  def create
    @avatar.asset = avatar_params[:asset]
    if @avatar.save
      @avatar.reload
      render json: @avatar.to_json
    else
      # si pb de type de PJ -> message spécifique pour interrompre le process
      if @avatar.errors.keys.include?(:asset_content_type)
        render status: 424, json: 'Ce type d\'image ne peut être ajouté'
      else # pb sur des champs classiques, affichage standard des erreurs
        render status: 422, json: { errors: @avatar.errors.full_messages.uniq }
      end
    end
  end

  def destroy
    if @avatar.destroy
      render json: { id: params[:id] }
    else
      render status: :unprocessable_entity, json: { errors: @avatar.errors.full_messages }
    end
  end


  private #=====================================================================


  def find_or_initialize_avatar
    @avatar = current_user.avatar || current_user.build_avatar
  end

  def avatar_params
    params
      .fetch(:asset_user_avatar) { {}.with_indifferent_access } # peut être vide
      .permit :id,
              :asset,
              :title,
              :custom_file_name,
              :format_type,
              :assetable_id
  end


end

