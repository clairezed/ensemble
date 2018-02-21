class SendNotification

  # Evenement annulé ==========================================
  def self.event_canceled(event)
    event.participants.email_notified.each do |user|
      EventMailer.event_canceled(user, event).deliver_later
    end
    event.participants.sms_notified.each do |user|
      Twilio::EventSmsSender.new.event_canceled(user, event)
    end
  end

  # Nouvelle invitation ==========================================
  def self.new_invitation(invitation)
    EventMailer.new_invitation(invitation).deliver_later if invitation.user.email_notification?
    Twilio::EventSmsSender.new.new_invitation(invitation) if invitation.user.sms_notification?
  end

  # Nouvelle invitation ==========================================
  def self.blocked_user_participating(user, event_participation)
    EventMailer.blocked_user_participating(user, event_participation).deliver_later if user.email_notification?
    Twilio::EventSmsSender.new.blocked_user_participating(user, event_participation) if user.sms_notification?
  end

  # Nouveau commentaire ==========================================
  def self.new_comment_on_your_event(user, comment)
    EventMailer.new_comment_on_your_event(user, comment).deliver_later if user.email_notification?
    Twilio::EventSmsSender.new.new_comment_on_your_event(user, comment) if user.sms_notification?
  end

  # Demande de témoignage ========================================
  def self.testimony_required(event)
    event.participants.email_notified.each do |user|
      EventMailer.testimony_required(user, event).deliver_later
    end
    event.participants.sms_notified.each do |user|
      Twilio::EventSmsSender.new.testimony_required(user, event)
    end
  end

  # Utilisateur bloqué par l'admin ===============================
  def self.admin_rejected(user)
    UserMailer.admin_rejected(user).deliver_later if user.email_notification?
    Twilio::UserSmsSender.new.admin_rejected(user) if user.sms_notification?
  end

end