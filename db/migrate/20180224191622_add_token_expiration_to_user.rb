class AddTokenExpirationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :account_token_expires, :datetime
  end
end
