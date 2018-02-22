class AddKeyToBasicPages < ActiveRecord::Migration[5.1]
  def change
    add_column :basic_pages, :key, :string
  end
end
