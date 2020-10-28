require 'oauth2'

class SpotifyController < ApplicationController

  SCOPE = 'playlist-modify-public playlist-read-private playlist-modify-private'.freeze

  def auth
    session[:redirect_to] = params[:redirect_to] unless params[:redirect_to].nil?
    session[:organization_id] = params[:organization_id] unless params[:organization_id].nil?

    url = client.auth_code.authorize_url(
      scope: SCOPE,
      redirect_uri: spotify_callback_url
    )
    redirect_to url
  end

  def complete
    token = client.auth_code.get_token(
      params[:code],
      redirect_uri: spotify_callback_url
    )

    store_token token
    redirect_to session[:redirect_to] || root_url
  end

  def token?
    organization_id = params[:organization_id]
    exists = SpotifyToken.exists?(organization_id: organization_id)
    render json: exists
  end

  private

  def store_token(token)
    spotify_token = SpotifyToken.find_by organization_id: session[:organization_id]
    spotify_token ||= SpotifyToken.new organization_id: session[:organization_id]

    spotify_token.token = token.to_json
    spotify_token.user_id = current_user.id

    spotify_token.save
  end

  def client
    OAuth2::Client.new(
      ENV['spotify_client_id'],
      ENV['spotify_secret'],
      site: 'https://accounts.spotify.com',
      authorize_url: '/authorize',
      token_url: '/api/token'
    )
  end
end
