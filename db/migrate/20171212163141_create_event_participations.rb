class CreateEventParticipations < ActiveRecord::Migration[5.1]
  def change
    create_table :event_participations do |t|
      t.references :event, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
