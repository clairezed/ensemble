class EventMailer < ApplicationMailer
  helper EventHelper
  helper UserHelper

  def event_canceled(user, event)
    @event = event
    @user = user
    subject = "Evénement annulé "
    mail to: @user.email, subject: subject
  end

end
