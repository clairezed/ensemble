module Statistics
  class ComputeEventStats

    def self.call(params)
      self.new(params).call
    end

    def initialize(params)
      @begin_at = params[:begin_at].to_date
      @end_at = params[:end_at].to_date
      @labels = []
      @new_events_data = []
      @total_events_data = []
    end

    def call
      compute_stats
      return formated_stats
    end

    private

    def compute_stats
      (@begin_at..@end_at).each do |day|
        stat               = Statistic.find_by_day(day.to_date)
        new_event_count    = stat.new_event_count rescue 0
        total_event_count  = stat.total_event_count rescue 0

        @labels << day.strftime("%d/%m")
        @new_events_data << new_event_count
        @total_events_data << total_event_count
      end
    end

    def formated_stats
      {
        labels: @labels,
        datasets: [
          formatted_new_events_dataset,
          formatted_total_events_dataset
        ]
      }
    end

    def formatted_new_events_dataset
      {
          label: 'nb évt nouveaux',
          data: @new_events_data,
          backgroundColor: 'rgba(248, 137, 97, 0.8)',
          borderColor: 'rgba(248, 137, 97, 1)',
          borderWidth: 1
        }
    end

    def formatted_total_events_dataset
      {
          label: 'nb évt total',
          data: @total_events_data,
          backgroundColor: 'rgba(64, 174, 180, 0.8)',
          borderColor: 'rgba(64, 174, 180, 1)',
          borderWidth: 1
        }
    end

  end

end