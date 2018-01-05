# frozen_string_literal: true

class Users::ParametersController < Users::BaseController

  before_action :find_user

  def show
  end

  def edit
  end

  def update
    if ::UpdateUserParameters.call(@user, parameters_params)
      flash[:notice] = "Paramètres mis à jour avec succès"
      redirect_to users_parameters_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour des paramètres"
      render :edit
    end
  end

  def edit_password
  end

  def update_password
    if ::UpdateUserParameters.call(@user, password_params)
      flash[:notice] = "Paramètres mis à jour avec succès"
      redirect_to users_parameters_path
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour des paramètres"
      render :edit_password
    end
  end

  private 
  
  def find_user
    @user = current_user
  end

  def parameters_params
    params.require(:user).permit(:email, :phone, 
      :sms_notification, :email_notification, 
      :current_password
      )
  end

  def password_params
    params.require(:user).permit(
      :password, :current_password, :password_confirmation
      )
  end

end
