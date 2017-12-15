module Twilio

  class EventSmsSender < Base

    # TODO : bon recipient + bon message
    def event_canceled(user, event)
      @event = event
      @user = user
      message = "Annulation evenement #{@event.title} le #{event.start_at.strftime("%d/%m/%Y")}"
      p message 
      # send_sms("event_canceled")
      # send_sms(message, user.phone )
    end

  end

end