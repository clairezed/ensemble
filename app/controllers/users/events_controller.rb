# frozen_string_literal: true

class Users::EventsController < Users::BaseController
 
  before_action :find_event, only: %i[edit update destroy]

  def index
    params[:sort_by] ||= :next_in_time
    @events = Search::Events.call(current_user, current_user.events.future, params)
  end

  def new
    @event = current_user.organized_events.new
  end

  def create  
    @event = current_user.organized_events.new(event_params)
    if @event.save
      flash[:notice] = "L'événement a bien été créé"
      if @event.closed?
        redirect_to users_event_invitations_path(@event)
      else
        redirect_to action: :index
      end
    else
      flash[:error] = "Une erreur s'est produite lors de la création de l'événement"
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      flash[:notice] = "L'événement a été modifié"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'événement"
      render :edit
    end
  end

  def destroy
    @event.cancel!
    flash[:notice] = "L'événement a été annulé"
    redirect_back fallback_location: event_path(@event)
  end

  private

  def find_event
    @event = current_user.organized_events.find params[:id]
  end

  # strong parameters
  def event_params
    EventService::PrepareParams.call(params.require(:event).permit(:title,
      :address, :city_id, :description, :participants_min, :participants_max, 
      :visibility, :leisure_category_id, :leisure_id, :start_date, :start_time, 
      :end_date, :end_time))
  end

end

