class CreatePCOSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_songs do |t|

      t.bigint :organization_id, null: false, index: true, unique: true

      t.string :title
      t.string :pco_id
      t.integer :ccli
      t.text :themes

      t.timestamps
    end
  end
end
