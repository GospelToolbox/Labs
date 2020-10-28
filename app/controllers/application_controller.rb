class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_token

  protected

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_token
    @current_token ||= current_user.account_token unless current_user.nil?
  end

  def authenticate_user!
    decision = current_user.nil? ||
               current_token.nil? ||
               current_user.account_token_expires.nil? ||
               current_user.account_token_expires <= Time.now

    session[:redirect_after_auth] = request.original_url

    redirect_to "/auth/sso" if decision
  end
end
