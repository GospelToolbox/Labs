module SetPlanner
  class PlanSong < ApplicationRecord
    belongs_to :pco_song, :class_name => 'PCO::Song'
    belongs_to :set_planner_plan, :class_name => 'SetPlanner::Plan'

  end
end
