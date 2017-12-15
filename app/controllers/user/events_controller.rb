# frozen_string_literal: true

class User::EventsController < User::BaseController
 
  before_action :find_event, only: %i[edit update destroy]

  def index
    @events = Search::Events.call(current_user, current_user.events.future, params).next_in_time
  end

  def new
    @event = current_user.organized_events.new
  end

  def create  
    @event = current_user.organized_events.new(event_params)
    # raise @event.inspect
    if @event.save
      flash[:notice] = "L'événement a été créée avec succès"
      if @event.closed?
        redirect_to event_path(@event)
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
      flash[:notice] = "L'événement a été mis à jour avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'événement"
      render :edit
    end
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

