# Handles login and logout operations.
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth ]

  # This method logs out a user
  #
  # @return [nil]
  def logout
    reset_session
    redirect_to welcome_path, notice: "You are logged out."
  end

  # This method calls the omniauth service
  #
  # @return [nil]
  def omniauth
    auth = request.env["omniauth.auth"]
    oauth_service = OauthService.new(auth, session[:user_id])
    result = oauth_service.connect_user

    if result[:success]
      session[:user_id] ||= result[:user].id
      redirect_to result[:success] ? games_path : user_path(result[:user]), notice: result[:notice]
    else
      redirect_to welcome_path, alert: result[:alert]
    end
  end
end
