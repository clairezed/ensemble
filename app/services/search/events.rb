module Search

  class Events < Base

    RESULTS_PER_PAGE = 10

    private # ==================

    def root_relation
      EventPolicy::Scope.new(user, initial_scope).resolve
        .includes(:leisure)
        .includes(:leisure_category)
        .includes(:city)
    end

    def result_per_page
      return params[:per_page] if params[:per_page].present? 
      RESULTS_PER_PAGE
    end

    def filter(relation)
      relation.apply_filters(params)
    end

    def sort(relation)
      return relation unless params[:sort_by].present?
      relation = relation.nearest_first(user.city.coordinates) if params[:sort_by].to_sym == :nearest_first
      relation = relation.default_sort(user.city.coordinates) if params[:sort_by].to_sym == :default_sort
      relation = relation.next_in_time if params[:sort_by].to_sym == :next_in_time
      relation = relation.older_last if params[:sort_by].to_sym == :older_last
      relation
    end

    def paginate(relation)
      relation.page(params[:page]).per(result_per_page)
    end

  end
end