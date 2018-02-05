class Users::SessionsController < Devise::SessionsController

  layout 'unregistered', except: [:destroy]

  skip_before_action :authenticate_user!, only: [:new, :create]  
  # before_action :configure_sign_in_params, only: [:create]

  # layout :set_layout
  
  # GET /resource/sign_in
  def new
    @last_events = Event.visible
      .includes(:leisure_category).includes(:city)
      .order(created_at: :desc).limit(3)
    @mirador_events = Event.visible.mirador
      .includes(:leisure_category).includes(:city)
      .order(created_at: :desc).limit(3)
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private 

end
