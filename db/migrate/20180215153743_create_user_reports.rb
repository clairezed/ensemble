class CreateUserReports < ActiveRecord::Migration[5.1]
  def change
    create_table :user_reports do |t|
      t.references :user, foreign_key: true, index: true
      t.references :reported_user, index: true, foreign_key: { to_table: :users }
      t.text :comment
      t.boolean :blocked, default: true
      t.timestamps
    end
  end
end
