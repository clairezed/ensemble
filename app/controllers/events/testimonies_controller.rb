class Events::TestimoniesController < Events::BaseController

  def new
    authorize @event, :testify?
    @testimony = @event.testimonies.new
  end

  def create
    authorize @event, :testify?
    @testimony = @event.testimonies.new(testimony_params)
    if @testimony.save
      flash[:notice] = "Merci ! Votre témoignage a été envoyé à l'administrateur"
      redirect_to action: :show, id: @testimony.id
    else
      flash[:error] = @testimony.errors.full_messages.first
      render action: :new
    end
  end

  def show
    # @testimony = @event.testimonies.find(:id)
  end

  def testimony_params
    params.require(:testimony).permit(
     :admin_comment, :public_comment
    ).merge(user_id: current_user.id)
  end

end