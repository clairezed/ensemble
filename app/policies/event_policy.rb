class EventPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def participate?
    !is_participant? && !is_organizer?
  end

  def cancel_participation?
    is_participant? && !is_organizer?
  end


  private #========================

  def is_organizer?
    record.user == user 
  end

  def is_participant?
    user.participation_at(record).present?
  end

end

