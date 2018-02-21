class AdminMailer < ApplicationMailer
  helper UserHelper
  
  def user_to_verify(user)
    @user = user
    subject = "Nouveau profil à vérifier"
    mail(subject: subject)
  end

  def comment_to_verify(comment)
    @comment = comment
    subject = "Nouveau commentaire à vérifier"
    mail(subject: subject)
  end

  def testimony_to_verify(testimony)
    @testimony = testimony
    subject = "Nouveau témoignage  à vérifier"
    mail(subject: subject)
  end


end