module SetPlanner
  class Plan < ApplicationRecord
    has_many :pco_plan_songs, class_name: 'SetPlanner::PlanSong', foreign_key: "set_planner_plan_id"

    SONGS_PER_WEEK = 4.5
    REPEATS_PER_PLAN = 3

    def songs_needed
      (number_of_weeks * SONGS_PER_WEEK / REPEATS_PER_PLAN).ceil
    end
  end
end
