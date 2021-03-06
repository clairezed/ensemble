class Users::SmsConfirmationsController < Users::BaseController
  skip_before_action :authenticate_user!
  layout 'unregistered', only: [:new]

  def new
    @user = User.new
    resource = @user
  end


  def create
    if send_sms_params[:phone].blank?
      @user = current_user.present? ? current_user : User.new
      @user.errors.add(:phone, :blank)
      render_new_view
    else
      phone = User::FormatPhoneNumber.call(send_sms_params[:phone])
      @user = User.where(phone: phone).first_or_initialize
      # Si on ne retrouve pas l'utilisateur
      if @user.new_record?
        flash[:error] = 'Il y a un problème avec votre numéro de téléphone'
        @user.errors.add(:phone, :not_corresponding_to_any_user)
        render_new_view
      else
        Twilio::SendConfirmationMessage.call(@user)
        flash[:notice] = 'Code envoyé'
        @code_sent = true
        render_new_view
      end
    end
  end


  def update
    @user = User.find(params[:id])
     respond_to do |format|
      format.html do 
        if User::ConfirmPhoneNumber.call(@user, update_params)
          redirect_to_after_sms_confirmation_path
        else
          flash[:error] = 'Il y a un problème avec le code sms'
          render_new_view
        end
      end
      # modal bienvenue affichée après l'inscription
      format.js do
        if User::ConfirmPhoneNumber.call(@user, update_params)
          render json: { success: true  }, content_type: 'application/json'
        else
          html = render_to_string(partial: "users/sms_confirmations/update")
          render json: { success: false, html: html }, content_type: 'application/json'
        end

      end
    end
  end

  private

  def update_params
    params.require(:user).permit(:sms_token)
  end


  def send_sms_params
    params.require(:user).permit(:phone)
  end

  def render_new_view
    if user_signed_in?
      render "users/parameters/show"
    else
      render :new
    end
  end


  def redirect_to_after_sms_confirmation_path
    if @user.identity_verified?
      sign_in @user unless user_signed_in?
      flash[:notice] = 'Votre profil a été entièrement vérifié'
      redirect_to authenticated_root_path
    elsif !@user.confirmed?
      flash[:notice] = 'Votre numéro de téléphone a été vérifié. Il vous reste à vérifier votre adresse email.'
      redirect_to (user_signed_in? ? users_parameters_path : new_confirmation_path(:user))
    else
      flash[:notice] = 'Votre numéro de téléphone a été vérifié'
      redirect_to (user_signed_in? ? users_parameters_path : user_new_session_path) 
    end
  end

  def resource
    @user
  end
  helper_method :resource

  def resource_name
    :user
  end
  helper_method :resource_name

end
