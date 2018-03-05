namespace :ensemble do

  desc "Calcul journalier du rang des utilisateurs"
  task compute_ranks: :environment do
    p "#{Time.zone.now} - Starting compute_ranks"
    Rails.logger.info "#{Time.zone.now} - Starting compute_ranks"
    User.find_each do |user|
      ComputeUserRank.call(user)
    end
    Rails.logger.info "Ending compute_ranks ========================= "
    p "Ending compute_ranks ========================="
  end

  desc "Envoi des demandes de témoignage"
  task send_testimony_demands: :environment do
    p "#{Time.zone.now} - Starting  send_testimony_demands"
    Rails.logger.info "#{Time.zone.now} - Starting send_testimony_demands"
    Event.active.ended_at(Date.yesterday).each do |event|
      p "Event #{event.id} : #{event.participants.count} participants"
      Rails.logger.info "Event #{event.id} : #{event.participants.count} participants"
      SendNotification.testimony_required(event)
    end
    Rails.logger.info "Ending send_testimony_demands ========================="
    p "Ending send_testimony_demands ========================="
  end

  desc "Génération journalière des statistiques"
  task generate_statistics: :environment do
    p "#{Time.zone.now} - Starting generate_statistics"
    Rails.logger.info "#{Time.zone.now} - Starting generate_statistics"
    date = Date.yesterday
    Statistic.generate!(date)
    Rails.logger.info "Ending generate_statistics ========================="
    p "Ending generate_statistics ========================="
  end

  desc "Suppression des utilisateurs inactifs"
  task delete_inactive_users: :environment do
    p "#{Time.zone.now} - Starting delete_inactive_users"
    Rails.logger.info "#{Time.zone.now} - Starting delete_inactive_users"
    inactive_date = 2.years.ago
    inactive_users = User.where(User.arel_table[:last_sign_in_at].lteq(inactive_date))
    inactive_users_count = inactive_users.count
    inactive_users.destroy_all
    Rails.logger.info "Ending delete_inactive_users - deleted #{inactive_users_count} users ========================="
    p "Ending delete_inactive_users - deleted #{inactive_users_count} users  ========================="
  end

end