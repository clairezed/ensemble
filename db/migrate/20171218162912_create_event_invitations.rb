class CreateEventInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :event_invitations do |t|
      t.references :event, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :state, default: 0
    end
  end
end
