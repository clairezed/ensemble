module Twilio

  class EventSmsSender < Base

    def event_canceled(user, event)
      @event = event
      @user = user
      message = "[Ensemble] L'événement #{@event.title} prévu le #{@event.start_at.strftime("%d/%m/%Y")} a été annulé."
      send_sms(message, @user.phone )
    end

    def testimony_required(user, event)
      @event = event
      @user = user
      message = "[Ensemble] Vous avez participé à #{@event.title} le #{@event.start_at.strftime("%d/%m/%Y")} à #{@event.city.name}. Donnez votre avis en vous rendant sur le site."
      send_sms(message, @user.phone )
    end

    def new_invitation(invitation)
      @invitation = invitation
      @event = invitation.event
      @user = invitation.user
      message = "[Ensemble] #{@event.user.nickname} vous invite à l'événement #{@event.title} le #{@event.start_at.strftime("%d/%m/%Y")}. Répondez 'OK #{@event.id}' pour accepter l'invitation."
      send_sms(message, @user.phone )
    end

    def blocked_user_participating(user, event_participation)
      @event_participation = event_participation
      @event = @event_participation.event
      @user = user
      message = "[Ensemble] #{@event_participation.user.nickname}, que vous avez bloqué, vient de s'inscrire à l'événément #{@event.title} prévu le #{@event.start_at.strftime("%d/%m/%Y")}"
      send_sms(message, @user.phone)
    end

    def new_comment_on_your_event(user, comment)
      @comment = comment
      @event = @comment.event
      @user = user
      message = "[Ensemble] #{@comment.user.nickname} a commenté #{@event.title}. Pour lire, connectez-vous à ENSEMBLE."
      send_sms(message, @user.phone)
    end

  end

end