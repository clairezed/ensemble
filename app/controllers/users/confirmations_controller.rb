class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :authenticate_user!

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # Surchargé pour voir si identity est verified
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty? 
      resource.verify_identity! if (resource.sms_confirmed? && resource.may_verify_identity?)

      set_flash_message!(:notice, :confirmed)
      # TODO : update to match sms_confirmations behaviour ?
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    if current_user.present?
      users_parameters_path
    else
      super(resource_name)
    end
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if resource.active_for_authentication?
      users_parameters_path
    elsif !resource.sms_confirmed?
      new_users_sms_confirmation_path
    else
      super(resource_name, resource)
    end
  end
end
