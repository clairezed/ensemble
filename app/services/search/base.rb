module Search

  class Base

    ITEM_TYPES ={
          ads: "Dans toutes les annonces",
          companies: "Dans toutes les startups",
          users: "Dans tous les profils"
    }

    attr_accessor :params, :user, :initial_scope

    def self.call(user, initial_scope, params={})
      self.new(user, initial_scope, params).call
    end

    def initialize(user, initial_scope, params={})
      self.params = params
      self.user = user
      self.initial_scope = initial_scope
    end

    def call
      @results ||= build_results
    end

    private

    def build_results
      [
        :filter,
        :sort,
        :paginate
      ].inject(root_relation) do |relation, filter|
        send filter, relation
      end
    end

  end
end