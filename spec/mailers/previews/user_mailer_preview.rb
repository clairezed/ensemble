
class UserMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/user_mailer/invitation
  def invitation
    UserMailer.invitation(UserInvitation.last)
  end
end