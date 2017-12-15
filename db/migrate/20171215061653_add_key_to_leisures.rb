class AddKeyToLeisures < ActiveRecord::Migration[5.1]
  def change
    add_column :leisures, :key, :string
    add_column :leisure_categories, :key, :string
  end
end
