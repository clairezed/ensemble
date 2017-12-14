# frozen_string_literal: true

class EventsController < ApplicationController

  def index
    @recommended_events = Search::RecommendedEvents.call(current_user, Event.visible, params)
      .nearest_first(current_user.city.coordinates)
      .next_in_time
    @last_events = Search::Events.call(current_user, Event.visible, params)
      .nearest_first(current_user.city.coordinates)
      .next_in_time
  end

  def show
    @event = Event.find params[:id]
  end
end
