namespace :ensemble do

  desc "Calcul journalier du rang des utilisateurs"
  task compute_ranks: :environment do
    p "Starting"
    Rails.logger.info "compute_ranks starting ==="
    User.find_each do |user|
      ComputeUserRank.call(user)
    end
    Rails.logger.info "compute_ranks ending"
    p "compute_ranks ending"
  end

  desc "Envoi des demandes de témoignage"
  task send_testimony_demands: :environment do
    p "Starting send_testimony_demands"
    Rails.logger.info "send_testimony_demands starting ==="
    Event.active.ended_at(Date.yesterday).each do |event|
      p "Event #{event.id} : #{event.participants.count} participants"
      Rails.logger.info "Event #{event.id} : #{event.participants.count} participants"
      SendNotification.testimony_required(event)
    end
    Rails.logger.info "send_testimony_demands ending"
    p "send_testimony_demands ending"
  end


end