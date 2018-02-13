module SearchHelper

  DISPLAYABLE_SEARCH_PARAMS = [:by_text, :by_dates, :by_city, :by_leisures]

  def dry_search_params(search_params)
    @dry_search_params ||= search_params.reject{|k,v| (v.blank? || !in_displayable_search_params?(k))}
  end

  def in_displayable_search_params?(val)
    DISPLAYABLE_SEARCH_PARAMS.include?(val.to_sym)
  end

  def search_params_icon(key)
    case key
    when 'by_text'              then icon_edit
    when 'by_leisures'          then icon_interest
    when 'by_dates'             then icon_calendar
    when 'by_city'              then icon_location
    else ''
    end
  end

  def search_params_label(key, val)
    case key
    when 'by_text'      then text_search_params(val)
    when 'by_leisures'  then leisures_search_params(val)
    when 'by_dates'     then date_range_search_params(val)
    when 'by_city'      then city_search_params(val)
    else val
    end
  end

  def text_search_params(val)
    return '' if val.blank?
    val
  end

  def leisures_search_params(vals)
    vals.map do |id|
      Leisure.find(id).try(:title) rescue ''
    end.join(", ")
  end

  def date_range_search_params(val)
    start_at, end_at = val.split("au")
    [l(start_at.to_date), l(end_at.to_date)].join(' -> ') rescue ''
  end


  def city_search_params(val)
    City.find(val).try(:name) rescue ''
  end

end