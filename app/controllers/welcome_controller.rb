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
        name: 'Preaching Calendar',
        description: 'Plan preaching schedules that can then sync with Planning Center Services',
        image: 'preaching_calendar.png',
        #url
      },
      {
        name: 'Set Planner',
        description: 'Song repertoire and schedule planning tools',
        image: 'set_planner.png',
        url: set_planner_url
      },
      {
        name: 'Planning Center Bot',
        description: 'Slack bot for routine service planning tasks',
        image: 'planning_center_bot.png',
        #url: 
      },
      {
        name: 'Ableton Export',
        description: 'Generate Ableton templates from Planning Center plans',
        image: 'pco_to_ableton.png',
        url: apps_ableton_url
      },
      {
        name: 'Spotify Playlist Sync',
        description: 'Generate Spotify Playlist from Planning Center songs and services',
        image: 'pco_to_spotify.png'
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
