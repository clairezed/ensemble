# frozen_string_literal: true

class EventsController < ApplicationController

  def index
    @events = Search::Events.call(current_user, Event, params)

     # Event.apply_filters(params).apply_sorts(params)
  end

  def show
    @event = Event.find params[:id]
  end
end
