# frozen_string_literal: true

class User::EventInvitationsController < User::BaseController
 
  before_action :find_event_invitation, only: %i[accept, reject]

  def index
    @event_invitations = current_user.event_invitations.pending
  end

  def accept
    @event_invitation.accept!
    redirect_to action: :index
  end



  private

  def find_event_invitation
    @event_invitation = current_user.event_invitations.find params[:id]
  end



end

