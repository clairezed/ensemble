
class UserMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/user_mailer/admin_rejected
  def admin_rejected
    UserMailer.admin_rejected(User.last)
  end

  # http://localhost:3000/rails/mailers/user_mailer/confirmation_instructions
  def confirmation_instructions
    user = User.last
    ::Devise::Mailer.confirmation_instructions(user, "insertRandomTokenHere")
  end
end