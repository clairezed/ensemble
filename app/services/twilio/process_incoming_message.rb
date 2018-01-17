module Twilio

  class ProcessIncomingMessage < Base

    RESPONSES = {
      unknown_phone_number: "Votre numéro de téléphone ne correspond pas à un membre d'Ensemble.",
      invitation_not_found: "Invitation non trouvée ou réponse incomplète. Pour accepter l'invitation: \"ok [n° fourni]\"",
      incomprehensible_message: "Réponse mal formattée. Pour accepter l'invitation: \"ok [n° fourni dans message précedent]\"",
      invitation_accepted: "L'invitation a bien été acceptée",
      unknown_problem: "Il y a eu un soucis, contactez un administrateur d'Ensemble",
    }

    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def call
      begin
        response = process_message
        xml_message(response)
      rescue => exception
        raise exception if Rails.env.development?
        xml_message(RESPONSES[:unknown_problem])
      end
    end


    private # ============================

    def identify_user
      phone_number = User::FormatPhoneNumber.call(params[:From])
      User.where(phone: phone_number).first
    end

    def process_message
      Rails.logger.warn "PROCESS INCOMING MESSAGE"
      # Identification expediteur -----------------------------
      @user = identify_user
      return RESPONSES[:unknown_phone_number] if @user.nil?
      # Identification invitation -----------------------------
      Rails.logger.warn params[:Body]
      Rails.logger.warn body
      answer, event_id = body.split(' ')
      Rails.logger.warn "answer / event_id : "
      Rails.logger.warn answer
      Rails.logger.warn event_id
      @event_invitation = @user.event_invitations.where(event_id: event_id).first
      return RESPONSES[:invitation_not_found] if @event_invitation.nil?
      # Envoyer un retour à la réponse -----------------------------
      if answer == 'ok'
        @event_invitation.accept!
        return RESPONSES[:invitation_accepted]
      else
        return RESPONSES[:incomprehensible_message]
      end
    end


    def body
      @body ||= params.fetch(:Body, '').downcase
    end

  end

end
