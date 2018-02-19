
class UserMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/user_mailer/admin_rejected
  def admin_rejected
    UserMailer.admin_rejected(User.last)
  end
end