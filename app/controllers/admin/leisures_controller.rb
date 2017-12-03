class Admin::LeisuresController < Admin::BaseController

  before_action :find_leisure, only: [:edit, :update, :destroy]

  def index
    @leisures = Leisure
      .apply_filters(params)
      .order(created_at: :desc)
      .page(params[:page]).per(20)
  end

  def new
    @leisure = Leisure.new
  end

  def create
    @leisure = Leisure.new(leisure_params)
    if @leisure.save
      flash[:notice] = "Le loisir a été créé avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du loisir"
      render :new
    end
  end

  def edit
  end

  def update
    if @leisure.update_attributes(leisure_params)
      flash[:notice] = "Leisuree mis à jour avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour du loisir"
      render :edit
    end
  end

  def destroy
    @leisure.destroy
    flash[:notice] = "Le loisir a été supprimé avec succès"
    redirect_to action: :index
  end

 
  private # =====================================================

  def leisure_params
    params.require(:leisure).permit(:title, :leisure_category_id)
  end

  def find_leisure
    @leisure = Leisure.find(params[:id])
  end
 
end