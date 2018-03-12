# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  # Tous les mails envoyés depuis une classe héritant de celle-ci
  # ont un sujet commençant par le même préfixe
  #
  SUBJECT_PREFIX = 'ensemble - '.freeze


  # Callbacks ==================================================================


  private def prefix_subject
      message.subject = [SUBJECT_PREFIX, message.subject].reject(&:blank?).join(' ')
  end
  after_action :prefix_subject
end
