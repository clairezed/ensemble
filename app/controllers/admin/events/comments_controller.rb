class Admin::Events::CommentsController < Admin::Events::BaseController 
  before_action :find_comment, only: [:accept, :reject]

  def index
    params[:sort] ||= "sort_by_created_at desc"
    @comments = @event.comments.apply_filters(params).page(params[:page]).per(10)
  end

  def accept
    @comment.accept!
    flash.notice = "Le commentaire a été accepté avec succès"
    redirect_to action: :index
  end

  def reject
    @comment.reject!
    flash.notice = "Le commentaire a été rejeté avec succès"
    redirect_to action: :index
  end

  private

  def find_comment
    @comment = @event.comments.find(params[:id])
  end
end