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
      send_sms(message, recipient_number)
    end

    private # =============================================================

    def client
      @client ||= Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
    end

    def send_sms(message = "test", recipient_number = DEFAULT_RECIPIENT_PHONE_NUMBER )
      p "SEND SMS ======================================"
      p "message"
      p message
      p "recipient_number"
      p recipient_number
      begin
        message = client.messages.create(
          body: message,
          to: recipient_number,    
          from: SENDER_PHONE_NUMBER)
      rescue Twilio::REST::TwilioError => e
        raise e
        puts e.message
        return false
      end
    end

    def xml_message(message_param)
      message = Twilio::TwiML::MessagingResponse.new
      message.message(body: message_param)
      return message
    end


  end

end