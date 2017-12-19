# frozen_string_literal: true

class User::Events::EventInvitationsController < User::Events::BaseController

  before_action :find_event_invitation, only: [:destroy]

  def index
    @invited_users = @event.event_invitations
    @leisure_users = EventService::GetInterestedUsers.call(@event, params)
  end

  def create
    @event_invitation = @event.event_invitations.new(event_invitation_params)
    if @event_invitation.save
      flash[:notice] = "Personne bien invitée"
      redirect_to action: :index
    else
      @invited_users = @event.event_invitations
      @leisure_users = EventService::GetInterestedUsers.call(@event, params)
      flash[:error] = "Une erreur s'est produite lors de l'invitation"
      render :index
    end
  end

  def destroy
    @event_invitation.destroy
    flash[:notice] = "L'invitation a bien été annulé"
    redirect_back fallback_location: user_event_invitations_path(@event)
  end

  private

  def find_event_invitation
    @event_invitation = @event.event_invitations.find params[:id]
  end

  def event_invitation_params
    params.require(:event_invitation).permit(:user_id)
  end


end