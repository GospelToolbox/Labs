require 'date'


class SessionsController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :authenticate_user!, except: :destroy

  def create
    auth_hash = request.env['omniauth.auth']
    user = get_or_create_user auth_hash[:info]

    user.account_token = auth_hash[:credentials][:token]
    user.account_token_expires = Time.at(auth_hash[:credentials][:expires_at]).to_datetime
    puts user.to_json
    user.save

    session[:user_id] = user.id

    if session[:redirect_after_auth].nil?
      redirect_to root_url
    else
      redirect_to session[:redirect_after_auth]
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to ENV['gtbox_account_host']
  end

  def failure; end

  private

  def get_or_create_user(info)
    user = User.find_by(uuid: info[:uuid]) || User.create(
      uuid: info[:uuid]
    )

    user.name = "#{info[:first_name]} #{info[:last_name]}"
    user.email = info[:email]

    user
  end
end
