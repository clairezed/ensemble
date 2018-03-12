module EventService

  class GetInterestedUsers

    attr_accessor :params

    def self.call(event, params)
      self.new(event, params).call
    end

    def initialize(event, params)
      @event = event
      self.params = params
    end

    def call
      [
        :filter_by_leisure,
        :near_organizer,
        :substract_organizer,
        :substract_invited_users,
        :substract_blocking_users,
        :paginate
      ].inject(User.all) do |relation, step|
        send(step, relation)
      end
    end

    private

    def filter_by_leisure(users)
      users.by_leisure_category(@event.leisure_category.id)
    end

    def substract_organizer(users)
      users.where.not(id: @event.user_id)
    end

    def substract_invited_users(users)
      users.where.not(id: @event.invited_user_ids)
    end

    def substract_blocking_users(users)
      users.where.not(id: User.blocking(@event.user_id))
    end

    def near_organizer(users)
      users
    end

    def paginate(users)
      users.page(params[:page]).per(4)
    end


  end
end