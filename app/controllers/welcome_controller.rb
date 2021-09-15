class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @labs = [
      {
        name: 'Team Schedule',
        description: 'Master schedule across all Planning Center teams',
        image: 'team_schedule.jpg',
        #url: apps_teamschedule_url
      },
      {
        name: 'Set Planner',
        description: 'Song repertoire and schedule planning tools',
        image: 'set_planner.png',
        url: set_planner_url
      }
    ]
  end
end
