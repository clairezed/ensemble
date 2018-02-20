
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

  # http://localhost:3000/rails/mailers/event_mailer/new_comment_on_your_event
  def new_comment_on_your_event
    comment = Comment.last
    user = comment.event.user
    EventMailer.new_comment_on_your_event(user, comment)
  end

  # http://localhost:3000/rails/mailers/event_mailer/event_canceled
  def event_canceled
    user = User.last
    event = Event.last
    EventMailer.event_canceled(user, event)
  end

end