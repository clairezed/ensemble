 class EventPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.not_blocked_to(user)
    end
  end

  def see?
    visible_event? || is_participant? || is_invited? || is_organizer?
  end

  def update?
    is_organizer? && record.active?
  end

  def cancel?
    is_organizer? && visible_event? && record.active?
  end

  def participate?
    visible_event? && !is_participant? && !is_organizer? && event_not_full?
  end

  def cancel_participation?
    visible_event? && is_participant? && !is_organizer?
  end


  private #========================

  def is_organizer?
    record.user == user 
  end

  def is_participant?
    user.participation_at(record).present?
  end

  def is_invited?
    user.participation_at(record).present?
  end

  def isnt_blocked_by_organizer?
    organizer = record.user
    organizer.active_report_for(user).blank?
  end

  def visible_event?
    record.visible? && isnt_blocked_by_organizer?
  end

  def event_not_full?
    !record.full?
  end

end

