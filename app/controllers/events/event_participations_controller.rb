class Events::EventParticipationsController < Events::BaseController

  def create
    @event_participation = @event.event_participations.new(user_id: current_user.id)
    if @event_participation.save
      flash[:notice] = 'Votre participation a été validée'
      redirect_to event_path(@event)
    else
      flash[:error] = @event_participation.errors.full_messages.first
      render "events/show"
    end
  end

  def destroy
    @event_participation = @event.event_participations.find(params[:id])
    @event_participation.destroy
      flash[:notice] = 'Votre participation a été annulée'
      redirect_to event_path(@event)
  end

end