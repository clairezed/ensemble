class SendNotification

  def self.event_canceled(event)
    event.participants.email_notified.each do |user|
      EventMailer.event_canceled(user, event).deliver_later
    end
    event.participants.sms_notified.each do |user|
      Twilio::EventSmsSender.new.event_canceled(user, event)
    end
  end

  def self.new_invitation(invitation)
    EventMailer.new_invitation(invitation).deliver_later if invitation.user.email_notification?
    Twilio::EventSmsSender.new.new_invitation(invitation) if invitation.user.sms_notification?
  end

end