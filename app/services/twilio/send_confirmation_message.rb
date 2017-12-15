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
      user.sms_confirmation_token = generate_one_time_password
      user.sms_confirmation_sent_at = Time.zone.now
      user.save!
    end

    def send_confirmation_sms
      # TODO - Update message
      message = "[Ensemble] #{user.sms_confirmation_token}"
      send_sms(message)
    end


  end

end