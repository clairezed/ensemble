class AddLeisures < ActiveRecord::Migration[5.1]
  def change

    create_table :leisure_categories do |t|
      t.string   :title
      t.timestamps
    end

    create_table :leisures do |t|
      t.references :leisure_category, index: true, foreign_key: true
      t.string   :title
      t.timestamps
    end

    create_table :leisure_interests do |t|
      t.references :leisure, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end

  end
end
