class ComputeUserRank

  attr_accessor :user

  def self.call(user)
    self.new(user).call
  end

  def initialize(user)
    self.user = user
  end

  def call
    if fullfill_ambassador_conditions
      user.ambassador! unless user.ambassador?
    elsif fullfill_expert_conditions
      user.expert! unless user.expert?
    elsif fullfill_regular_conditions
      user.regular! unless user.regular?
    else
      user.beginner! unless user.beginner?
    end
  end

  private

  def fullfill_regular_conditions
    identity_verified && participated(2)
  end

  def fullfill_expert_conditions
    identity_verified && avatar && participated(4) && organized(1)
  end

  def fullfill_ambassador_conditions
    identity_verified && avatar && participated(6) && organized(2)
  end

  # ---------------------------------

  def identity_verified
    user.sms_confirmed? && user.confirmed?
  end

  def participated(count)
    valid_participated_events.count >= count
  end

  def organized(count)
    valid_organized_events.count >= count
  end

  def avatar
    user.avatar.present?
  end

  # ------------------------

  def valid_participated_events
    @valid_participated_events ||= Event.past.active.with_participant(user.id)
  end

  def valid_organized_events
    @valid_organized_events ||= Event.past.active.organized_by(user.id)
  end





  end