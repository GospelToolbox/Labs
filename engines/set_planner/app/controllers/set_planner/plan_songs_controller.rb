require_dependency "set_planner/application_controller"

module SetPlanner
  class PlanSongsController < ApplicationController
    def destroy
      @plan_song = SetPlanner::PlanSong.find(params[:id])
      @plan_song.destroy

      redirect_to SetPlanner::Plan.find(params[:plan_id])
    end
  end
end
