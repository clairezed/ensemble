module Twilio

  class EventSmsSender < Base

    def event_canceled(user, event)
      @event = event
      @user = user
      message = "ensemble - L'événement #{@event.title} prévu le #{@event.start_at.strftime("%d/%m/%Y")} est annulé."
      send_sms(message, @user.phone )
    end

    def testimony_required(user, event)
      @event = event
      @user = user
      message = "ensemble - Vous avez participé à #{@event.title} le #{@event.start_at.strftime("%d/%m/%Y")} à #{@event.city.name}. Donnez votre avis en allant sur le site."
      send_sms(message, @user.phone )
    end

    def new_invitation(invitation)
      @invitation = invitation
      @event = invitation.event
      @user = invitation.user
      message = "ensemble - #{@event.user.nickname} vous invite à l'événement #{@event.title} le #{@event.start_at.strftime("%d/%m/%Y")}. Répondez 'OK #{@event.id}' pour accepter l'invitation."
      send_sms(message, @user.phone )
    end

    def blocked_user_participating(user, event_participation)
      @event_participation = event_participation
      @event = @event_participation.event
      @user = user
      message = "ensemble - #{@event_participation.user.nickname}, que vous avez bloqué, vient de s'inscrire à l'événément #{@event.title} prévu le #{@event.start_at.strftime("%d/%m/%Y")}. Connectez-vous à ensemble."
      send_sms(message, @user.phone)
    end

    def new_comment_on_your_event(user, comment)
      @comment = comment
      @event = @comment.event
      @user = user
      message = "ensemble - #{@comment.user.nickname} a commenté #{@event.title}. Pour lire, connectez-vous à ensemble."
      send_sms(message, @user.phone)
    end

    def comment_rejected(comment)
      @comment = comment
      @user = @comment.user
      message = "ensemble - Votre commentaire est refusé par l'administrateur. Il ne respecte les CGU. Contact : contact@ensemble-app.fr"
      send_sms(message, @user.phone)
    end

  end

end