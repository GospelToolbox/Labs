class CreatePlanningCenterTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :planning_center_tokens do |t|
      t.bigint :organization_id, null: false, index: true, unique: true
      t.string :token, null: false
      t.bigint :user_id, null: false, index: true

      t.timestamps
    end

  end
end
