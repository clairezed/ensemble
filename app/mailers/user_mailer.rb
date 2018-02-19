class UserMailer < ApplicationMailer
  helper UserHelper

  def admin_rejected(user)
    @user = user
    subject = "Votre profil a été bloqué par l'administrateur"
    mail to: @user.email, subject: subject
  end

end
