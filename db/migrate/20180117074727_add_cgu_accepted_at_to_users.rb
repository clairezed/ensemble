class AddCguAcceptedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :cgu_accepted_at, :datetime
  end
end
