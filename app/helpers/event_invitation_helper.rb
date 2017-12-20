# frozen_string_literal: true

module EventInvitationHelper

  # Etat -----------------------------------------------

  def event_invitation_state_title(state)
    I18n.t(state, scope: %i(event_invitation states title))
  end

  def event_invitation_state_style(state)
    I18n.t(state, scope: %i(event_invitation states style))
  end

  def event_invitation_state_options(states = EventInvitation.states.keys)
    states.map do |state|
      [event_invitation_state_title(state), state.to_s]
    end
  end


end