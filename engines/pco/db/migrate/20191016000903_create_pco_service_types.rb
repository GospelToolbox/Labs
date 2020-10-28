class CreatePCOServiceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_service_types do |t|
      
      t.bigint :organization_id, null: false, index: true, unique: true

      t.string :pco_id
      t.string :name

      t.timestamps
    end
  end
end
