# frozen_string_literal: true

class SmsNotificationsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    message = Twilio::ProcessIncomingMessage.call(params)
    render xml: message.to_s
  end
end