# frozen_string_literal: true

class SmsNotificationsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    p "INDEX SmsNotificationsController ================================="
    p params
    message = Twilio::ProcessIncomingMessage.call(params)
    p message
    render xml: message.to_s
  end
end