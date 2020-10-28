require_dependency "set_planner/application_controller"

module SetPlanner
  class SongsController < ApplicationController
    def index
      @songs = PCO::SongNormalized.where(hidden: false).order(score: :desc)
    end

    def show
      @song = PCO::Song.find(params[:id])
    end
  end
end
