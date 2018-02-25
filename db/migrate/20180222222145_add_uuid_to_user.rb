class AddUuidToUser < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'uuid-ossp'
    add_column :users, :uuid, :uuid, default: "uuid_generate_v4()", null: false
  end
end
