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
    key == 'female' ? icon_women : icon_men
  end

  def user_gender_head_icon(key)
    key == 'female' ? icon_women_hair : icon_men_mustache
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

  # Grade -------------------------------------

  def user_rank_title(rank)
    I18n.t(rank, scope: [:user, :ranks, :title])
  end

  def user_rank_style(state)
    I18n.t(state, scope: %i(user ranks style))
  end

  def user_rank_options(states = User.ranks.keys)
    states.map do |state|
      [user_rank_title(state), state.to_s]
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

  # Admin -----------------------------------------

  def user_options(users = User.all)
    users.map do |user|
      [user.fullname, user.id]
    end
  end



end