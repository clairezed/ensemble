#encoding: utf-8
class Admin::UsersController < Admin::BaseController

  before_action :find_user, except: [ :index, :new, :create ]

  def index
    params[:sort] ||= "sort_by_created_at desc"
    @users = User.apply_filters(params).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

      flash[:notice] = "L'utilisateur a été créé avec succès"
      redirect_to params[:continue].present? ? edit_admin_user_path(@user) : users_redirect_path
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'utilisateur"
      render :new
    end
  end

  def edit
  end

  def update
    @user.attributes = user_params
    if @user.save

      flash[:notice] = "L'utilisateur a été mis à jour avec succès"
      redirect_to params[:continue].present? ? edit_admin_user_path(@user) : admin_users_path(by_user_type: @user.user_type)
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'utilisateur"
      render :edit
    end
  end

  def destroy
    user_type = @user.user_type
    @user.destroy
    flash[:notice] = "L'utilisateur a été supprimé définitivement avec succès"
    redirect_to admin_users_path(by_user_type: user_type)
  end

  def confirm
    @user.confirm
    flash[:notice] = "L'inscription a été validée avec succès"
    redirect_to users_redirect_path
  end

  # def reactivate
  #   @user.reactivate!
  #   flash[:notice] = "L'utilisateur a été réactivé avec succès"
  #   redirect_to users_redirect_path
  # end

  # def block
  #   @user.block!
  #   flash.notice = "Le compte a été bloqué avec succès"
  #   redirect_to action: :index
  # end

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
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :title, :city, :display_name,
    :gender, :lastname, :firstname, :country, :google_place_id, :nickname, :company, :profession, :avatar, :language,
    :about, :website, :youtube_channel, :vimeo_channel, :dailymotion_channel, :user_type, :facebook_account, :twitter_account,
    company_address: [:street_number, :road, :region, :zipcode])
  end

end
