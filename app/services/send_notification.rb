class SendNotification

  def self.event_canceled(event)
    event.participants.email_notified.each do |user|
      EventMailer.event_canceled(user, event).deliver_later
    end
    event.participants.sms_notified.each do |user|
      Twilio::EventSmsSender.new.event_canceled(user, event)
    end
  end

end