# frozen_string_literal: true

module UserHelper


  def is_current_user?(user)
    user == current_user
  end

  # Name --------------------------------------

  def user_nickname(user)
    @user_nickname ||= [user.firstname, initials(user.lastname)].join(" ")
  end

  def initials(val)
    val.split.map{|v| v[0].capitalize }.join('')
  end

  # Genders -------------------------------------

  def user_gender(gender)
    I18n.t(gender, scope: [:user, :genders])
  end

  # def user_gender_options(genders = User.genders.keys)
  #   user_gender_full_options(genders)
  # end

  # Age

  def user_age(birthdate)
    return if birthdate.blank?
    if @age.blank?
      now = Date.today
      @age = now.year - birthdate.year - ((now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day)) ? 0 : 1)
    end
    [@age, 'ans'].join(' ')
  end

  # Sorting -----------------------------------------

  # def user_sorting_options(option_keys = User::SORTING_OPTIONS)
  #   option_keys.map do |key|
  #     [user_sorting_option(key), key]
  #   end
  # end

  # def user_sorting_option(key)
  #   I18n.t(key, scope: [:sorting, :user])
  # end

end