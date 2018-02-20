class Events::CommentsController < Events::BaseController

  def create
    @comment = @event.comments.new(comment_params)
    if @comment.save
      flash[:notice] = "Votre commentaire a été envoyé à l'administrateur pour validation"
      redirect_to event_path(@event)
    else
      flash[:error] = @comment.errors.full_messages.first
      render "events/show"
    end
  end

  def comment_params
    params.require(:comment).permit(
     :body
    ).merge(user_id: current_user.id)
  end

end