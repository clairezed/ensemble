class AddVerificationStateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :verification_state, :integer, default: 0
  end
end
