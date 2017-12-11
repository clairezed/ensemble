class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :title
      t.string :key
      t.timestamps
    end

    create_table :user_languages do |t|
      t.references :language, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
