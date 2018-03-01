class CreateStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :statistics do |t|
      t.date :day
      t.integer :new_user_count,        default: 0
      t.integer :total_user_count,      default: 0
      t.integer :registered_user_count, default: 0
      t.integer :new_event_count,       default: 0
      t.integer :total_event_count,     default: 0
      t.timestamps
    end
  end
end


