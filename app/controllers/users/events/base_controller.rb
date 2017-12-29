# frozen_string_literal: true

class Users::Events::BaseController < Users::BaseController  

  before_action :load_event

  private

  def load_event
    @event = Event.find(params[:event_id])
  end

end