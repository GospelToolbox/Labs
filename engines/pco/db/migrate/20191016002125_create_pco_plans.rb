class CreatePCOPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :pco_plans do |t|

      t.bigint :organization_id, null: false, index: true, unique: true
      t.belongs_to :pco_service_type

      t.string :pco_id
      t.datetime :date

      t.string :title
      t.string :series_title

      t.timestamps
    end
  end
end
