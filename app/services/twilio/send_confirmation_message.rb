module Twilio

  class SendConfirmationMessage < Base

    attr_accessor :user

    def initialize(user)
      self.user = user
    end

    def call
      save_sms_confirmation_token
      send_confirmation_sms
    end


    private # ============================

    def generate_one_time_password
      OneTimePassword::Generate.call(user.id)
    end

    def save_sms_confirmation_token
      user.update_columns(
        sms_confirmation_token: generate_one_time_password,
        sms_confirmation_sent_at: Time.zone.now
      )
      # user.sms_confirmation_token = generate_one_time_password
      # user.sms_confirmation_sent_at = Time.zone.now
      # user.save!
    end

    def send_confirmation_sms
      message = "Bienvenue sur ensemble ! Le code à écrire sur le site pour vérifier votre numéro de téléphone est le suivant : #{user.sms_confirmation_token}"
      send_sms(message, user.phone)
    end


  end

end
