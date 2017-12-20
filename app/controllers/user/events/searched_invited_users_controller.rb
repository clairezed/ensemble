class User::Events::SearchedInvitedUsersController < User::Events::BaseController


  def index
    @users = EventService::GetSearchableUsers.call(@event, params).limit(5)
    @no_search = params[:by_val].blank?
    respond_to do |format|
      format.html do
        @users
      end
      format.js
    end
  end
  
end