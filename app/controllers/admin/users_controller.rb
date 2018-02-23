#encoding: utf-8
class Admin::UsersController < Admin::BaseController

  before_action :find_user, except: [ :index, :new, :create ]

  def index
    params[:sort] ||= "sort_by_created_at desc"
    @users = User.includes(:avatar).apply_filters(params).page(params[:page]).per(20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(profile_params)
    if @user.save
      flash[:notice] = "L'utilisateur a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_user_path(@user) : users_redirect_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'utilisateur"
      render :new
    end
  end

  def edit_profile
  end

  def update_profile
    @user.attributes = profile_params
    if @user.save
      flash[:notice] = "L'utilisateur a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_profile_admin_user_path(@user) : admin_users_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'utilisateur"
      render :edit_profile
    end
  end

  def edit
  end

  def update
    if @user.update_without_password(parameters_params)
      flash[:notice] = "Paramètres mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_user_path(@user) : admin_users_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour des paramètres"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = "L'utilisateur a été supprimé définitivement avec succès"
    redirect_to admin_users_path
  end

  def confirm
    @user.confirm
    flash[:notice] = "L'inscription a été validée avec succès"
    redirect_to users_redirect_path
  end

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

  # def sign_as
  #   signed_as_user = User.find(params[:id])
  #   sign_in(:user, signed_as_user, { :bypass => true })
  #   cookies[:sudo] = true
  #   flash[:notice] = "Vous êtes désormais connecté en tant que #{signed_as_user.nickname}"
  #   redirect_to root_url
  # end

  private

  def find_user
    @user = User.find params[:id]
  end

  def users_redirect_path
    (url_for(user_search_params.merge(action: :index)))
  end

  # strong parameters
  def profile_params
    params.require(:user).permit(:firstname, :lastname, :gender, :phone, :birthdate, :description, :city_id, :visited_countries, 
      language_ids: [], leisure_ids: [],
      avatar_attributes: [ :id, :asset, :_destroy])
  end


  def parameters_params
    p = params.require(:user).permit(:email, :phone, 
      :sms_notification, :email_notification, 
      :affiliation
      )
    # p.merge!(params.require(:user).permit(:password, :password_confirmation)) if params[:user][:password].present?
    p
  end

end
