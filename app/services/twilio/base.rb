module Twilio

  class Base

  ACCOUNT_SID                     = Rails.application.secrets.twilio_account_sid
  AUTH_TOKEN                      = Rails.application.secrets.twilio_auth_token
  SENDER_PHONE_NUMBER             = Rails.application.secrets.twilio_phone_number
  # DEFAULT_RECIPIENT_PHONE_NUMBER  = '+33612310286'
  DEFAULT_RECIPIENT_PHONE_NUMBER  = '+33628055148'


    def self.call(*params)
      self.new(*params).call
    end

    def call(message = '', recipient_number = DEFAULT_RECIPIENT_PHONE_NUMBER)
      send_sms(message)
    end

    private # =============================================================

    def client
      @client ||= Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
    end

    def send_sms(message = "test", recipient_number = DEFAULT_RECIPIENT_PHONE_NUMBER )
      begin
        message = client.messages.create(
          body: message,
          to: recipient_number,    
          from: SENDER_PHONE_NUMBER)
      rescue Twilio::REST::TwilioError => e
        puts e.message
        return false
      end
    end


  end

end