class AdminMailer < ApplicationMailer


  def user_to_verify(user)
    @user = user
    subject = "Nouveau profil à vérifier"
    mail(subject: subject)
  end


end