# frozen_string_literal: true

module CommentHelper

  # Etat -----------------------------------------------

  def comment_state_title(state)
    I18n.t(state, scope: %i(comment states title))
  end

  def comment_state_style(state)
    I18n.t(state, scope: %i(comment states style))
  end

  def comment_state_options(states = Comment.states.keys)
    states.map do |state|
      [comment_state_title(state), state.to_s]
    end
  end

end