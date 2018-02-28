class CreateAppsTeamScheduleSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :apps_team_schedule_schedules do |t|
      t.bigint :organization_id, null: false, index: true, unique: true
      t.string :schedule
      t.datetime :last_updated

      t.timestamps
    end
  end
end
