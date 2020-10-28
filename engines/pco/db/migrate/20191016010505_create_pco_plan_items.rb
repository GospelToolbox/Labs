class CreatePCOPlanItems < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_plan_items do |t|

      t.bigint :organization_id, null: false, index: true, unique: true

      t.belongs_to :pco_plan
      t.belongs_to :pco_song, optional: true
      t.belongs_to :pco_arrangement, optional: true
      t.belongs_to :pco_key, optional: true

      t.string :pco_id

      t.string :name
      t.text :description
      t.string :item_type
      t.integer :length
      t.text :service_position
      t.integer :service_sequence
      t.text :custom_arrangement_sequence


      t.timestamps
    end
  end
end
