class Admin::EventsController < Admin::BaseController

  before_action :find_event, only: [:edit, :update, :destroy]

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
    flash[:notice] = "L'événement a bien été annulé"
    redirect_back fallback_location: event_path(@event)
  end

  def destroy
    @event.destroy
    flash[:notice] = "L'événement a été supprimé avec succès"
    redirect_to action: :index
  end

 
  private # =====================================================

  def event_params
    params.require(:event).permit(:title, :event_category_id)
  end

  def find_event
    @event = Event.find(params[:id])
  end
 
end