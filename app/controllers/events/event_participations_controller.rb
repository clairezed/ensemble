class Events::EventParticipationsController < Events::BaseController

  def create
    @event_participation = @event.event_participations.new(user_id: current_user.id)
    if @event_participation.save
      flash[:notice] = 'Votre participation a bien été prise en compte'
      redirect_to event_path(@event)
    else
      flash[:error] = 'Il y a eu un problème'
      render "events/show"
    end
  end

  def destroy
    @event_participation = @event.event_participations.find(params[:id])
    @event_participation.destroy
      flash[:notice] = 'Votre participation a bien été annulée'
      redirect_to event_path(@event)
  end

end