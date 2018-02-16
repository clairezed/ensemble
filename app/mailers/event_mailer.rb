class EventMailer < ApplicationMailer
  helper EventHelper
  helper UserHelper

  def event_canceled(user, event)
    @event = event
    @user = user
    subject = "Evénement annulé "
    mail to: @user.email, subject: subject
  end

  def new_invitation(invitation)
    @invitation = invitation
    @user = invitation.user
    @event = invitation.event
    subject = "Nouvelle invitation"
    mail to: @user.email, subject: subject
  end

  def blocked_user_participating(user, event_participation)
    @event_participation = event_participation
    @user = user
    subject = "Une personne bloquée participe au même événement que vous"
    mail to: @user.email, subject: subject
  end

end
