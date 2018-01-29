class AddVisitedCountriesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :visited_countries, :text
  end
end
