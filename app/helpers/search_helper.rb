module SearchHelper

  def display_search_params(key, val)
    case key
    when 'by_text'              then text_search_params(val)
    when 'by_leisure_category'  then leisure_category_search_params(val)
    when 'by_dates'             then date_range_search_params(val)
    when 'by_city'              then city_search_params(val)
    else val
    end
  end

  def text_search_params(val)
    return '' if val.blank?
    val
  end

  def leisure_category_search_params(val)
    LeisureCategory.find(val).try(:title) rescue ''
  end

  def date_range_search_params(val)
    start_at, end_at = val.split("au")
    [l(start_at.to_date), l(end_at.to_date)].join('-') rescue ''
  end


  def city_search_params(val)
    City.find(val).try(:name) rescue ''
  end

end