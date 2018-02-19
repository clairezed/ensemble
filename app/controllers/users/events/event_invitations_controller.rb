# frozen_string_literal: true

class Users::Events::EventInvitationsController < Users::Events::BaseController

  before_action :find_event_invitation, only: [:destroy]

  def index
    @invited_users = @event.event_invitations
    @leisure_users = EventService::GetInterestedUsers.call(@event, params)
  end

  def create
    @event_invitation = @event.event_invitations.new(event_invitation_params)
    if @event_invitation.save
      flash[:notice] = "L'invitation est prête à être envoyée"
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
    flash[:notice] = "L'invitation a été annulée"
    redirect_back fallback_location: users_event_invitations_path(@event)
  end

  # Valide les invitations en attente
  def batch_valildate
    @event.event_invitations.each do |invitation|
      invitation.validate! if invitation.may_validate?
    end
    flash[:notice] = "Les invitations ont été validées et envoyées"
    redirect_to users_events_path
  end

  private

  def find_event_invitation
    @event_invitation = @event.event_invitations.find params[:id]
  end

  def event_invitation_params
    params.require(:event_invitation).permit(:user_id)
  end


end