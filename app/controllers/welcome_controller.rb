class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @labs = [
      {
        name: 'Team Schedule',
        description: 'Master schedule across all Planning Center teams',
        image: 'team_schedule.jpg',
        url: apps_teamschedule_url
      },
      {
        name: 'Ableton Export',
        description: 'Generate Ableton templates from Planning Center plans',
        image: 'pco_to_ableton.png'
        # url: apps_ableton_url
      },
      {
        name: 'Missional Community Groups',
        description: 'Tools for missional community group clusters',
        image: 'mcg_clusters.png'
      }
    ]
  end
end
