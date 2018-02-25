require 'oauth2'

class PlanningCenterController < ApplicationController

  SCOPE = 'people services'.freeze

  def auth
    session[:redirect_to] = params[:redirect_to] unless params[:redirect_to].nil?
    session[:organization_id] = params[:organization_id] unless params[:organization_id].nil?

    url = client.auth_code.authorize_url(
      scope: SCOPE,
      redirect_uri: pco_callback_url
    )
    redirect_to url
  end

  def complete
    token = client.auth_code.get_token(
      params[:code],
      redirect_uri: pco_callback_url
    )

    store_token token
    redirect_to session[:redirect_to] || root_url
  end

  def token?
    organization_id = params[:organization_id]
    puts organization_id
    exists = PlanningCenterToken.exists?(organization_id: organization_id)
    render json: exists
  end

  private

  def store_token(token)
    pco_token = PlanningCenterToken.find_by organization_id: session[:organization_id]
    pco_token ||= PlanningCenterToken.new organization_id: session[:organization_id]

    pco_token.token = token.to_json
    pco_token.user_id = current_user.id

    pco_token.save
  end

  def client
    OAuth2::Client.new(
      ENV['pco_client_id'],
      ENV['pco_secret'],
      site: 'https://api.planningcenteronline.com'
    )
  end
end
