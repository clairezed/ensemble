# frozen_string_literal: true

class MiradorEventsController < ApplicationController

  def index
    params[:sort_by] ||= :default_sort
    @events = Search::Events.call(current_user, Event.visible.mirador, params)
  end

end
