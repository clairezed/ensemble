class Admin::Events::BaseController < Admin::BaseController
  before_action :load_event

  private

  def load_event
    @event = Event.includes(:comments).includes(:testimonies)
      .find(params[:event_id])
  end

end