require_dependency "set_planner/application_controller"

module SetPlanner
  class ArrangementsController < ApplicationController
    def show
      @song = PCO::Song.find(params['song_id'])
      @arrangement = PCO::Arrangement.find(params['id'])
    end
  end
end
