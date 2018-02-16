# frozen_string_literal: true

class EventsController < ApplicationController

  def index
    params[:sort_by] ||= :default_sort
    @recommended_events = Search::RecommendedEvents.call(current_user, Event.visible, params).limit(3)
    @last_events = Search::Events.call(current_user, Event.visible.normal, params).limit(3)
    @mirador_events = Search::Events.call(current_user, Event.visible.mirador, params)
  end

  def show
    @event = Event.find params[:id]
    authorize @event, :see?
  end
end
