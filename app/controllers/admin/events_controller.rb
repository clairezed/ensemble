class Admin::EventsController < Admin::BaseController

  before_action :find_event, only: [:edit, :update, :destroy, :cancel, :activate]

  def index
    @events = Event
      .apply_filters(params)
      .apply_sorts(params)
      .page(params[:page]).per(20)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = "L'événement a été créé avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'événement"
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      flash[:notice] = "L'événement a été mis à jour avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de l'événement"
      render :edit
    end
  end

  def cancel
    @event.cancel!
    # TODO Notif oragnisateur ?
    flash[:notice] = "L'événement a bien été annulé"
    redirect_back fallback_location: event_path(@event)
  end

  def activate
    @event.activate!
    flash[:notice] = "L'événement a bien été réactivé"
    redirect_back fallback_location: event_path(@event)
  end

  def destroy
    @event.destroy
    flash[:notice] = "L'événement a été supprimé avec succès"
    redirect_to action: :index
  end

 
  private # =====================================================

  def event_params
    EventService::PrepareParams.call(params.require(:event).permit(:title,
      :address, :city_id, :description, :participants_min, :participants_max, 
      :visibility, :leisure_category_id, :leisure_id, :start_date, :start_time, 
      :end_date, :end_time, :affiliation))
  end

  def find_event
    @event = Event.find(params[:id])
  end
 
end