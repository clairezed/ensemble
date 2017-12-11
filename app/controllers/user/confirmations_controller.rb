class User::ConfirmationsController < Devise::ConfirmationsController
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
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    if current_user.present?
      edit_user_registration_path
    else
      super(resource_name)
    end
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if current_user.present?
      edit_user_registration_path
    else
      super(resource_name, resource)
    end
  end
end
