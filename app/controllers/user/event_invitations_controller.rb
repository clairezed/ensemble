# frozen_string_literal: true

class User::EventInvitationsController < User::BaseController
 
  before_action :find_event_invitation, except: %i[index]

  def index
    @event_invitations = current_user.event_invitations.pending
  end

  def accept
    @event_invitation.accept!
    flash[:notice] = "L'invitation a bien été acceptée"
    redirect_to action: :index
  end

  def reject
    @event_invitation.reject!
    flash[:notice] = "L'invitation a bien été rejetée"
    redirect_to action: :index
  end

  # reponse email
  def edit
    if params[:query].present? and params[:query] == 'accept'
      @event_invitation.accept!
      flash[:notice] = "L'invitation a bien été acceptée"
      redirect_to action: :index
    elsif params[:query].present? and params[:query] == 'reject'
      @event_invitation.reject!
      flash[:notice] = "L'invitation a bien été rejetée"
      redirect_to action: :index
    else
      flash[:notice] = "Nous n'avons pas retrouvé cette invitation"
      redirect_to action: :index
    end
  end



  private

  def find_event_invitation
    @event_invitation = current_user.event_invitations.find params[:id]
  end



end

