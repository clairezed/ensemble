class Users::RegistrationsController < Devise::RegistrationsController

  layout 'unregistered', only: [:new, :create, :new_second_step, :create_second_step]

  skip_before_action :authenticate_user!, only: [:new, :create]
  skip_before_action :check_registration_uncomplete, only: [:new_second_step, :create_second_step]
  skip_before_action :reject_blocked_ip!, except: [:edit, :update]


  before_action :configure_sign_up_params, only: [:create]
  before_action :find_user, only: [:new_second_step, :create_second_step, :edit_profile, :update_profile]

  def new
    get_seo_for_static_page('home')
    @last_events = Event.active.order(created_at: :desc).limit(3)
    @mirador_events = Event.active.mirador.order(created_at: :desc).limit(3)
    @user = User.new_with_session({}, session)
  end


  # Premier formulaire d'inscription -------------------------------
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      # custom 
      @user = resource
      @last_events = Event.active.order(created_at: :desc).limit(3)
      @mirador_events = Event.active.mirador.order(created_at: :desc).limit(3)
      render action: :new
    end
  end

  # Second formulaire d'inscription ------------------
  def new_second_step
    @user.build_avatar unless @user.avatar
  end

  def create_second_step
    @user.attributes = second_step_params
    if @user.save
      finalize_registration
      flash[:notice] = "Votre inscription a bien été finalisée"
      redirect_to users_parameters_path(anchor: 'verify-identity')
    else
      @user.build_avatar unless @user.avatar
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'utilisateur"
      render :new_second_step
    end
  end

  # Edition informations principales --------------------------
  def edit
    @user.build_avatar unless @user.avatar
  end

  def update
    @user.attributes = profile_params
    if @user.save
      flash[:notice] = "Votre profil a été mis à jour avec succès"
      redirect_to profile_path(@user)
    else
      @user.build_avatar unless @user.avatar
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de votre profil"
      render :edit
    end
  end


  # DELETE /resource
  # def destroy
  #   super
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :email, :password, :password_confirmation, :remember_me,
      :firstname, :lastname
    ])
  end

  def second_step_params
    params.require(:user).permit(:phone, :sms_notification, :email_notification, :cgu_accepted, 
    *profile_params_array )
  end

  def profile_params
    params.require(:user).permit(*profile_params_array)
  end

  
  # #If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [
  #     :email, :phone, :sms_notification, :email_notification, 
  #     :password, :current_password, :password_confirmation])
  # end

  def profile_params_array
    [:gender, :phone, :birthdate, :description, :city_id, 
      language_ids: [], leisure_ids: [], 
      avatar_attributes: [ :id, :asset, :_destroy]]
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    new_second_step_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end


  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def finalize_registration
    @user.update(registration_complete: true, cgu_accepted_at: Time.current)
    Twilio::SendConfirmationMessage.call(@user)
  end

  private 
  
  def find_user
    @user = current_user
  end

end
