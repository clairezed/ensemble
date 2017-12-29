# frozen_string_literal: true

class Users::PastEventsController < Users::BaseController
 
  def index
    @events = Search::Events.call(current_user, current_user.events.past, params).next_in_time
  end

end