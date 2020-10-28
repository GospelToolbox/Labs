class CreateSetPlannerPlanSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :set_planner_plan_songs do |t|

      t.belongs_to :set_planner_plan
      t.belongs_to :pco_song

      t.timestamps
    end
  end
end
