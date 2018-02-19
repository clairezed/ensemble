module Twilio

  class UserSmsSender < Base

    def admin_rejected(user)
      @user = user
      message = "[Ensemble] Votre compte ENSEMBLE est désactivé. Vous n'avez pas respecté les CGU. Contact : contact@ensemble-app.fr"
      p message 
      # send_sms("event_canceled")
      send_sms(message, @user.phone )
    end

  end

end