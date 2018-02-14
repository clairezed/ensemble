# frozen_string_literal: true

module RankHelper

  # visibilities -------------------------------------

  def user_rank_title(rank)
    I18n.t(rank, scope: [:user, :ranks, :title])
  end
end