
class Statistic < ActiveRecord::Base

  # Associations =================================================================


  # Validations ==================================================================


  # Callbacks ====================================================================


  # Scopes =======================================================================

  scope :between, ->(beginning, ending) {
    where(day: beginning.to_date..ending.to_date)
  }

  # Class methods ================================================================

  # Création d'une entrée statistique journalière, avec toutes les données
  # à visualiser dans le temps (!= à un instant T)
  def self.generate!(date = Date.current)

    stat = self.create(day: date) do |stat|
      stat.new_user_count                 = User.created_in_day(date).count
      stat.total_user_count               = User.created_before(date).count
      stat.registered_user_count          = User.with_registration_completed.created_before(date).count
      stat.new_event_count                = Event.created_in_day(date).count
      stat.total_event_count              = Event.created_before(date).count
    end

  end

  # Méthode permettant de générer toutes les stats sur le dernier mois
  # (dans une optique de test)
  def self.generate_for_last_month
    (1.month.ago.to_date..Date.current).each do |day|
      self.generate!(day)
    end
  end


  # Instance methods ================================================================



  private # ======================================================================


end
