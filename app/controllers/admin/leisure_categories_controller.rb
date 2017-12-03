class Admin::LeisureCategoriesController < Admin::BaseController

  before_action :find_leisure_category, only: [:edit, :update, :destroy]

  def index
    @leisure_categories = LeisureCategory
      .order(created_at: :desc)
      .page(params[:page]).per(20)
  end

  def new
    @leisure_category = LeisureCategory.new
  end

  def create
    @leisure_category = LeisureCategory.new(leisure_category_params)
    if @leisure_category.save
      flash[:notice] = "La famille de loisirs a été créé avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la famille de loisirs"
      render :new
    end
  end

  def edit
  end

  def update
    if @leisure_category.update_attributes(leisure_category_params)
      flash[:notice] = "La famille de loisirs a été mis à jour avec succès"
      redirect_to action: :index
    else
      flash[:error] = "Une erreur s'est produite lors de la mise à jour de la famille de loisirs"
      render :edit
    end
  end

  def destroy
    @leisure_category.destroy
    flash[:notice] = "La famille de loisirs a été supprimé avec succès"
    redirect_to action: :index
  end

 
  private # =====================================================

  def leisure_category_params
    params.require(:leisure_category).permit(:title)
  end

  def find_leisure_category
    @leisure_category = LeisureCategory.find(params[:id])
  end
 
end