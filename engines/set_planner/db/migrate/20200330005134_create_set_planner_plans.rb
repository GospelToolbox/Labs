class CreateSetPlannerPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :set_planner_plans do |t|

      t.string :title
      t.text :description
      t.datetime :start_date
      t.integer :number_of_weeks

      t.timestamps
    end
  end
end
