# frozen_string_literal: true

class User::Events::BaseController < User::BaseController  

  before_action :load_event

  private

  def load_event
    @event = Event.find(params[:event_id])
  end

end