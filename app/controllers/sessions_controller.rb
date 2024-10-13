# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth, :github]

  def logout
    reset_session
    redirect_to welcome_path, notice: "You are logged out."
  end

  def omniauth
    if session[:user_id].present?
      session[:guest] = nil
      auth = request.env["omniauth.auth"]

      @user = UserService.find_user_by_id(session[:user_id])

      if @user.valid?
        @user.update(email: auth["info"]["email"])
      end
      redirect_to user_path(@user), notice: "Connected Google account."
    else
      reset_session
      auth = request.env["omniauth.auth"]

      @user = UserService.find_or_create_user(auth)

      if @user.valid?
        session[:user_id] = @user.id
        redirect_to games_path
      else
        redirect_to welcome_path, alert: "Login failed."
      end
    end
  end

  def github
    if session[:user_id].present?
      session[:guest] = nil
      auth = request.env["omniauth.auth"]

      @user = UserService.find_user_by_id(session[:user_id])

      if @user.valid?
        @user.update(github_username: auth["info"]["nickname"])
      end
      redirect_to user_path(@user), notice: "Connected Github account."
    else
      reset_session
      auth = request.env["omniauth.auth"]

      @user = UserService.github_user(auth)

      if @user.valid?
        session[:user_id] = @user.id
        redirect_to games_path
      else
        redirect_to welcome_path, alert: "Login failed."
      end
    end
  end
end
