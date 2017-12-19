class EventPolicy < ApplicationPolicy

  class Scope < Scope
    # TODO : pas événements privés ou je suis pas invité
    # TODO : pas événements organisés/ par qqn qui m'a bloqué
    def resolve
      scope
    end
  end

  def update?
    is_organizer? && record.active?
  end

  def cancel?
    is_organizer? && visible_event? && record.active?
  end

  def participate?
    visible_event? && !is_participant? && !is_organizer?
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

  def visible_event?
    record.visible?
  end

end

