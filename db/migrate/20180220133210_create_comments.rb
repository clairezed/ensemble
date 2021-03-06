class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true, index: true
      t.references :event, index: true, foreign_key: true
      t.text :body
      t.integer :state
      t.timestamps
    end
  end
end
