# frozen_string_literal: true

class User::PastEventsController < ApplicationController
 
  def index
    @events = Search::Events.call(current_user, current_user.events.past, params)
  end

end

