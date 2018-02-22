# frozen_string_literal: true

class Users::PastEventsController < Users::BaseController
 
  def index
    params[:sort_by] ||= :older_last
    @events = Search::Events.call(current_user, current_user.events.past, params)
  end

end