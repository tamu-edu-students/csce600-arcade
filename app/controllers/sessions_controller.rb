# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth ]

  def logout
    reset_session
    redirect_to welcome_path, notice: "You are logged out."
  end

  def omniauth
    auth = request.env["omniauth.auth"]

    @user = UserService.find_or_create_user(auth)

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "You are logged in."
    else
      redirect_to welcome_path, alert: "Login failed."
    end
  end
end
