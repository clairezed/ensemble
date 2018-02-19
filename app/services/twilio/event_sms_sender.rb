module Twilio

  class EventSmsSender < Base

    # TODO : bon recipient + bon message
    def event_canceled(user, event)
      @event = event
      @user = user
      message = "[Ensemble] L'événement #{@event.title} prévu le #{@event.start_at.strftime("%d/%m/%Y")} a été annulé."
      p message 
      # send_sms("event_canceled")
      send_sms(message, @user.phone )
    end

    def new_invitation(invitation)
      @invitation = invitation
      @event = invitation.event
      @user = invitation.user
      message = "[Ensemble] #{@event.user.nickname} vous invite à l'événement #{@event.title} le #{@event.start_at.strftime("%d/%m/%Y")}. Répondez 'OK #{@event.id}' pour accepter l'invitation."
      p message 
      # send_sms("new invit, rep \"ok #{@event.id}\" pour accepter")
      send_sms(message, @user.phone )
    end

    def blocked_user_participating(user, event_participation)
      @event_participation = event_participation
      @event = @event_participation.event
      @user = user
      message = "[Ensemble] #{@event_participation.user.nickname}, que vous avez bloqué, vient de s'inscrire à l'événément #{@event.title} prévu le #{@event.start_at.strftime("%d/%m/%Y")}"
      p message 
      # send_sms("new invit, rep \"ok #{@event.id}\" pour accepter")
      send_sms(message, @user.phone)
    end

  end

end