module Twilio

  class ProcessIncomingMessage < Base

    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def call
      begin
        @user = identify_user
        if @user.nil?
          @response = "Num tel inconnu."
        else
          answer, event_id = body.split(' ')
          p "answer : #{answer}"
          p "event_id : #{event_id}"
          @event_invitation = @user.event_invitations.where(event_id: event_id).first
          if @event_invitation.nil?
            @response = "No invit found"
          else
            if answer == 'ok'
              @event_invitation.accept!
              @response = "Accepted"
            else
              @response = "answer unknown"
            end
          end
        end
        p @response
        xml_message(@response)
        # true
      rescue
        xml_message("Pb, contact admin")
      #   raise exception
      #   false
      end
    end


    private # ============================

    def identify_user
      p params[:From]
      phone_number = User::FormatPhoneNumber.call(params[:From])
      p phone_number
      User.where(phone: phone_number).first
    end

    # def process_message 
    #   answer, event_id = body.split(' ')
    #   @event = Event.where(id: event_id).first
    #   if @event.nil?
    #     @response = "No event"
    #   else
    #   end
    # end

    # def accept_event_invitation
    #   @event_invitation = @user.event_invitations.where(event_id: @event.id)
    #   @event_invitation.accept!
    #   @response = "Accepted"
    # end

    def body
      @body ||= params.fetch(:Body, '').downcase
    end

  end

end
