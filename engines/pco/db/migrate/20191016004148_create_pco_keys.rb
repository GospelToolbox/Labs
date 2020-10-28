class CreatePCOKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_keys do |t|

      t.bigint :organization_id, null: false, index: true, unique: true
      t.belongs_to :pco_arrangement

      t.string :pco_id

      t.string :name
      t.text :alternate_keys
      t.string :starting_key
      t.string :ending_key
      t.boolean :starting_minor
      t.boolean :ending_minor

      t.timestamps
    end
  end
end
