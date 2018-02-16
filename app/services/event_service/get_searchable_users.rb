module EventService

  class GetSearchableUsers

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
        :filter_by_nickname,
        :substract_organizer,
        :substract_invited_users,
        :substract_blocking_users,
        :limit
      ].inject(user_base_scope) do |relation, step|
        send(step, relation)
      end
    end

    private

    def user_base_scope
      User.visible
    end

    def filter_by_nickname(users)
      users.by_nickname(params[:by_val], strict: true)
    end

    def substract_organizer(users)
      users.where.not(id: organizer)
    end

    def substract_invited_users(users)
      users.where.not(id: @event.invited_user_ids)
    end

    def substract_blocking_users(users)
      users.where.not(id: User.blocking(organizer.id))
    end

    def limit(users)
      users.limit(5)
    end

    def organizer
      @organizer ||= @event.user
    end

  end
end