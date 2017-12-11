# frozen_string_literal: true

class User::EventsController < ApplicationController
 
  before_action :find_event, only: %i[edit update destroy]

  def index
    @events = Search::Events.call(current_user, current_user.events.future, params)
  end

  def new
    @event = current_user.events.new
  end

  def create  
    @event = current_user.events.new(event_params)
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

    private

  def find_event
    @event = BasicPage.from_param params[:id]
  end

  # strong parameters
  def event_params
    params.require(:event).permit(:title, :start_at, 
      :address, :city_id, :description, :participants_min, :participants_max, 
      :visibility)
  end

end

