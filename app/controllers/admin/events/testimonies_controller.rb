class Admin::Events::TestimoniesController < Admin::Events::BaseController 
  before_action :find_testimony, only: [:edit, :update, :accept, :reject]

  def index
    params[:sort] ||= "sort_by_created_at desc"
    @testimonies = @event.testimonies.apply_sorts(params).page(params[:page]).per(10)
  end


  def edit
  end

  def update
    if @testimony.update_attributes(testimony_params)
      flash[:notice] = "Le témoignage a été mis à jour avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du témoignage"
      render :edit
    end
  end


  def accept
    @testimony.accept!
    flash.notice = "Le témoignage a été accepté avec succès"
    redirect_to action: :index
  end

  def reject
    @testimony.reject!
    flash.notice = "Le témoignage a été rejeté avec succès"
    redirect_to action: :index
  end

  private

  def find_testimony
    @testimony = @event.testimonies.find(params[:id])
  end

  def testimony_params
    params.require(:testimony).permit(:admin_comment, :public_comment)
  end


end