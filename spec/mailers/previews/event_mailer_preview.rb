
class EventMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/event_mailer/new_invitation
  def new_invitation
    EventMailer.new_invitation(EventInvitation.last)
  end

end