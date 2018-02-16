
class EventMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/event_mailer/new_invitation
  def new_invitation
    EventMailer.new_invitation(EventInvitation.last)
  end

  # http://localhost:3000/rails/mailers/event_mailer/blocked_user_participating
  def blocked_user_participating
    user = User.last
    event_participation = EventParticipation.last
    EventMailer.blocked_user_participating(user, event_participation)
  end

end