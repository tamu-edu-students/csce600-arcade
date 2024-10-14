# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth, :github, :spotify]

  def logout
    reset_session
    redirect_to welcome_path, notice: "You are logged out."
  end

  def omniauth
    if session[:user_id].present?
      session[:guest] = nil
      auth = request.env["omniauth.auth"]

      @user = UserService.find_user_by_id(session[:user_id])
      existing_user = UserRepository.find_by_email(auth["info"]["email"])

      if existing_user
        redirect_to user_path(@user), alert: "Account already exists."
      else
        if @user.valid?
          @user.update(email: auth["info"]["email"])
        end
        redirect_to user_path(@user), notice: "Connected Google account."
      end
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
      existing_user = UserRepository.find_by_gu(auth["info"]["nickname"])

      if existing_user
        redirect_to user_path(@user), alert: "Account already exists with those credentials."
      else
        if @user.valid?
          @user.update(github_username: auth["info"]["nickname"])
        end
        redirect_to user_path(@user), notice: "Connected Github account."
      end
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

  def spotify
    if session[:user_id].present?
      session[:guest] = nil
      auth = request.env["omniauth.auth"]

      @user = UserService.find_user_by_id(session[:user_id])
      existing_user = UserRepository.find_by_su(auth["extra"]["raw_info"]["id"])

      if existing_user
        redirect_to user_path(@user), alert: "Account already exists with those credentials."
      else
        if @user.valid?
          @user.update(spotify_username: auth["extra"]["raw_info"]["id"])
          session[:spotify_access_token] = auth["credentials"]["token"]
        end
        redirect_to user_path(@user), notice: "Connected Spotify account."
      end
    else
      reset_session
      auth = request.env["omniauth.auth"]

      @user = UserService.spotify_user(auth)

      if @user.valid?
        session[:user_id] = @user.id
        session[:spotify_access_token] = auth["credentials"]["token"]
        redirect_to games_path
      else
        redirect_to welcome_path, alert: "Login failed."
      end
    end
  end
end
