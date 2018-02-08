module Search

  class Base

    RANGE_SEPARATOR = "au"

    attr_accessor :params, :user, :initial_scope

    def self.call(user, initial_scope, params={})
      self.new(user, initial_scope, params).call
    end

    def initialize(user, initial_scope, params={})
      self.params = parse_params(params)
      self.user = user
      self.initial_scope = initial_scope
    end

    def call
      @results ||= build_results
    end

    private

    def parse_params(params)
      params = params.merge(parse_params_by_dates(params[:by_dates])) if params[:by_dates].present?
      params
    end

    def parse_params_by_dates(date_params)
      start_at, end_at = date_params.split(RANGE_SEPARATOR)
      range_params = {}
      range_params[:by_start_at] = parsed_time(start_at).beginning_of_day rescue nil
      range_params[:by_end_at] = parsed_time(end_at).end_of_day rescue nil
      range_params
    end


    def parsed_time(val)
      val.in_time_zone
    end


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