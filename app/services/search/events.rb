module Search

  class Events < Base

    RESULTS_PER_PAGE = 20

    private # ==================

    def root_relation
      EventPolicy::Scope.new(user, initial_scope).resolve
        .includes(:user)
    end

    def result_per_page
      return params[:per_page] if params[:per_page].present? 
      RESULTS_PER_PAGE
    end

    def filter(relation)
      relation.apply_filters(params)
    end

    def sort(relation)
      relation.apply_sorts(params)
    end

    def paginate(relation)
      relation.page(params[:page]).per(result_per_page)
    end

  end
end