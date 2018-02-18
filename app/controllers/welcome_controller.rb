class WelcomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @labs = [
      {
        name: 'Team Schedule',
        description: 'Master schedule across all Planning Center teams',
        image: 'team_schedule.jpg'
      },
      {
        name: 'Ableton Export',
        description: 'Generate Ableton templates from Planning Center plans',
        image: 'pco_to_ableton.png'
      },
      {
        name: 'Missional Community Groups',
        description: 'Tools for missional community group clusters',
        image: 'mcg_clusters.png'
      }
    ]
  end
end
