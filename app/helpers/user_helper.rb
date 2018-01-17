# frozen_string_literal: true

module UserHelper

  def is_current_user?(user)
    user == current_user
  end

  # Name --------------------------------------

  def user_nickname(user)
    [user.firstname, initials(user.lastname)].join(" ")
  end

  def initials(val)
    val.split.map{|v| v[0].capitalize }.join('')
  end

  # Genders -------------------------------------

  def user_gender(gender)
    I18n.t(gender, scope: [:user, :genders])
  end

  def user_gender_icon(key)
    key == 'female' ? 'fa-female' : 'fa-male'
  end

  def user_affiliation(affiliation)
    I18n.t(affiliation, scope: [:user, :affiliations])
  end

  # Etat -----------------------------------------------

  def user_verification_state_title(state)
    I18n.t(state, scope: %i(user verification_states title))
  end

  def user_verification_state_style(state)
    I18n.t(state, scope: %i(user verification_states style))
  end

  def user_verification_state_options(states = User.verification_states.keys)
    states.map do |state|
      [user_verification_state_title(state), state.to_s]
    end
  end

  # def user_gender_options(genders = User.genders.keys)
  #   user_gender_full_options(genders)
  # end

  # Age

  def user_age(birthdate)
    return if birthdate.blank?
    now = Date.today
    age = now.year - birthdate.year - ((now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day)) ? 0 : 1)
    [age, 'ans'].join(' ')
  end

  # Profil verification --------------------------------

  def phone_verified_status(user)
    if user.sms_confirmed?
      "Numéro de téléphone vérifié"
    else
      "Numéro de téléphone non vérifié"
    end
  end

  def email_verified_status(user)
    if user.confirmed?
      "Adresse email vérifiée"
    else
      "Adresse email non vérifiée"
    end
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