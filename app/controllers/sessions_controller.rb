class SessionsController < ApplicationController
  protect_from_forgery except: :create

  def create
    auth_hash = request.env['omniauth.auth']
   
    user = User.find_by(email: auth_hash[:info][:email])

    if !user
      user = User.new :name => auth_hash[:info][:name], :email => auth_hash[:info][:email]
      user.save
    end

    session[:user_id] = user.id    
    redirect_to root_url, :notice => "Signed in!"
  end

  def failure
  end

end