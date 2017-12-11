class AddSmsConfirmationFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sms_confirmation_token, :string
    add_column :users, :sms_confirmed_at, :datetime
    add_column :users, :sms_confirmation_sent_at, :datetime
  end
end
