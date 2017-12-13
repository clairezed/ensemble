class Events::BaseController < ApplicationController
  before_action :load_event

  private

  def load_event
    @event = Event.find(params[:event_id])
  end

end