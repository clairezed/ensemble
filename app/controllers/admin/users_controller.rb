#encoding: utf-8
class Admin::UsersController < Admin::BaseController

  before_action :find_user, except: [ :index, :new, :create ]

  def index
    params[:sort] ||= "sort_by_created_at desc"
    @users = User.includes(:avatar).apply_filters(params).page(params[:page]).per(20)
  end

  # paramètres ---------------------
  def edit
  end

  def update
    if params[:user][:password].blank?
      @user.attributes = user_params.except(:password, :password_confirmation)
    else
      @user.attributes = user_params
    end
    @user.skip_reconfirmation!
    if @user.save
      flash[:notice] = "Paramètres mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_user_path(@user) : admin_users_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour des paramètres"
      render :edit
    end
  end

  # se connecter en tant que tel utilisateur
  # bypass : pour ne pas enregistrer last_sign_in_at et current_sign_in
  def sign_as
    signed_as_user = User.find(params[:id])
    sign_in(:user, signed_as_user, { :bypass => true })
    cookies[:ens_sudo] = true
    flash[:notice] = "Vous êtes désormais connecté en tant que #{signed_as_user.fullname}"
    redirect_to authenticated_root_url
  end

  # se déconnecter en tant qu'utilisateur et se reconnecter comme admin
  # bypass : pour ne pas enregistrer last_sign_in_at et current_sign_in
  def sign_out_as
    sign_out(:user)
    cookies.delete :ens_sudo
    redirect_to admin_root_url
  end

  def destroy
    @user.destroy
    flash[:notice] = "L'utilisateur a été supprimé définitivement avec succès"
    redirect_to admin_users_path
  end

  # def confirm
  #   @user.confirm
  #   flash[:notice] = "L'inscription a été validée avec succès"
  #   redirect_to users_redirect_path
  # end

  def accept
    @user.admin_accept!
    flash.notice = "L'utilisateur a été accepté avec succès"
    redirect_to action: :index
  end

  def reject
    @user.admin_reject!
    flash.notice = "L'utilisateur a été rejeté et bloqué avec succès"
    redirect_to action: :index
  end

  private

  def find_user
    @user = User.find params[:id]
  end

  def user_params
    p = params.require(:user).permit(:email, :phone, 
      :sms_notification, :email_notification, :password, :password_confirmation, 
      :affiliation
      )
    # p.merge!(params.require(:user).permit(:password, :password_confirmation)) if params[:user][:password].present?
    p
  end

end
