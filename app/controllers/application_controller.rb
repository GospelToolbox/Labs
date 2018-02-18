class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
 
  private
 
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    if !current_user
      redirect_to '/auth/sso'
    end
  end
end
  