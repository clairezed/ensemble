module IconsHelper

  def render_icon(icon_title, path_count, classes=nil)
    content_tag(:span, class: "ico ico-#{icon_title} #{classes}") do 
      (1..path_count).each do |i|
        concat content_tag(:span, '', class: "path#{i}")
      end
    end
  end

  # Liste des icon ====================================

  # Menu bas -----------------------------------------

  def icon_profile_reverse
    render_icon('profile-reverse', 2)
  end

  def icon_bell
    render_icon('bell', 3)
  end

  def icon_bell_notif
    render_icon('bell-notif', 5)
  end

  def icon_add_reverse(classes)
    render_icon('add-reverse', 4, classes)
  end

  def icon_calendar_reverse
    render_icon('calendar-reverse', 14)
  end

end