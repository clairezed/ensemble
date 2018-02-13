module IconsHelper

  def render_icon(icon_title, path_count, classes=nil)
    # if path_count = 1
    #   return content_tag(:span, class: "ico ico-#{icon_title} #{classes}")
    # else
      content_tag(:span, class: "ico ico-#{icon_title} #{classes}") do 
        (1..path_count).each do |i|
          concat content_tag(:span, '', class: "path#{i}")
        end
      end
    # end
  end



  # Liste des icon ====================================

  def icon_add(classes=nil)
    render_icon('add', 4, classes)
  end

  def icon_add_reverse(classes=nil)
    render_icon('add-reverse', 4, classes)
  end

  def icon_attachment
    render_icon('attachment', 6)
  end

  def icon_bell
    render_icon('bell', 3)
  end

  def icon_bell_notif
    render_icon('bell-notif', 5)
  end

  def icon_calendar
    render_icon('calendar', 6)
  end

  def icon_calendar_futur
    render_icon('calendar-future', 14)
  end

  def icon_calendar_past
    render_icon('calendar-past', 14)
  end

  def icon_calendar_reverse
    render_icon('calendar-reverse', 14)
  end

  def icon_camera
    render_icon('camera', 5)
  end

  def icon_cgu
    render_icon('cgu', 7)
  end

  def icon_clock
    render_icon('clock', 20)
  end

  def icon_close
    render_icon('close', 4)
  end

  def icon_country
    render_icon('country', 3)
  end

  def icon_country_reverse
    render_icon('country-reverse', 1)
  end

  def icon_delete
    render_icon('delete', 5)
  end

  def icon_delete_reverse
    render_icon('delete-reverse', 5)
  end

  def icon_desktop
    render_icon('desktop', 9)
  end

  def icon_disconnect
    render_icon('disconnect', 2)
  end

  def icon_edit
    render_icon('edit', 2)
  end

  def icon_edit_reverse
    render_icon('edit-reverse', 2)
  end

  def icon_hamburger
    render_icon('hamburger', 6)
  end

  def icon_home
    render_icon('home', 2)
  end

  def icon_interest
    render_icon('interest', 2)
  end

  def icon_language
    render_icon('language', 6)
  end

  def icon_location
    render_icon('location', 54)
  end

  def icon_mail
    render_icon('mail', 2)
  end

  def icon_mail_reverse
    render_icon('mail-reverse', 1)
  end

  def icon_men
    render_icon('men', 3)
  end

  def icon_men_mustache
    render_icon('men-mustache', 2)
  end

  def icon_mentions
    render_icon('mentions', 4)
  end

  def icon_mirador
    render_icon('mirador', 6)
  end

  def icon_mirador_participant
    render_icon('mirador-participant', 7)
  end

  def icon_mobile_phone
    render_icon('mobile-phone', 8)
  end

  def icon_people
    render_icon('people', 2)
  end

  def icon_profile
    render_icon('profile', 2)
  end

  def icon_profile_reverse
    render_icon('profile-reverse', 2)
  end

  def icon_search
    render_icon('search', 2)
  end

  def icon_search_reverse
    render_icon('search-reverse', 2)
  end

  def icon_settings
    render_icon('settings', 2)
  end

  def icon_women
    render_icon('women', 3)
  end

  def icon_women_hair
    render_icon('women-hair', 2)
  end

end