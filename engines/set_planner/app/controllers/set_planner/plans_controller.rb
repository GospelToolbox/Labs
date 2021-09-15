module SetPlanner
  class PlansController < ApplicationController
    def index
      @plans = SetPlanner::Plan.all
    end

    def create
      @plan = SetPlanner::Plan.new(plan_params)
 
      @plan.save
      redirect_to @plan
    end

    def new
    end

    def edit
    end

    def show
      @plan = SetPlanner::Plan.find(params[:id])
    end

    def gather
      @plan = SetPlanner::Plan.find(params[:id])

      @songs = PCO::SongNormalized.where(hidden: false)
               .where.not(id: @plan.pco_plan_songs.map { |ps| ps.pco_song_id }) 
               .order('score DESC NULLS LAST')
    end

    def refine
      @plan = SetPlanner::Plan.find(params[:id])
    end

    def enrich
      @plan = SetPlanner::Plan.find(params[:id])
    end

    def publish
      @plan = SetPlanner::Plan.find(params[:id])
    end

    def select_song
      @plan = SetPlanner::Plan.find(params[:id])
      @song = PCO::Song.find(params[:song_id])

      @plan_song = SetPlanner::PlanSong.new(set_planner_plan: @plan, pco_song: @song)
      @plan_song.save

      redirect_to gather_plan_path(@plan)
    end

    def update
    end

    def destroy
    end

    private

    def plan_params
      params.require(:plan).permit(:title, :description, :start_date, :number_of_weeks)
    end
  end
end