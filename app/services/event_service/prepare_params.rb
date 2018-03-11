module EventService

  class PrepareParams

  attr_accessor :params

  def self.call(params={})
    self.new(params).call
  end

  def initialize(params={})
    self.params = params
  end

  # Méthode custom pour gérer un peu plus finement la mise à jour
  # et les messages d'erreur.
  def call
    set_start_at
    set_end_at
    return params
  end

  private 

  def set_start_at
    if params[:start_date].present? 
      start_date_param = Time.zone.parse([ params[:start_date], params[:start_time] ].join(" "))
      params[:start_at] = start_date_param
      params.delete(:start_date)
      params.delete(:start_time)
    end
  end

  def set_end_at
    if params[:end_date].present?
      end_date_param = Time.zone.parse([ params[:end_date], params[:end_time] ].join(" "))
      params[:end_at] = end_date_param
    end
    params.delete(:end_date)
    params.delete(:end_time)
  end

  end
end