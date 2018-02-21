class CreateTestimonies < ActiveRecord::Migration[5.1]
  def change
    create_table :testimonies do |t|
      t.references :user, foreign_key: true, index: true
      t.references :event, index: true, foreign_key: true
      t.text :admin_comment
      t.text :public_comment
      t.integer :state
      t.datetime :accepted_at
      t.timestamps
    end
  end
end
