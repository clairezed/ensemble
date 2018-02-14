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

end