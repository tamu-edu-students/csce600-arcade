# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth, :github, :spotify ]

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
        redirect_to user_path(@user), alert: "Account already exists with those credentials."
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
    auth = request.env["omniauth.auth"]

    if session[:user_id].present?
      session[:guest] = nil
      @user = UserService.find_user_by_id(session[:user_id])
      existing_user = UserRepository.find_by_gu(auth["info"]["nickname"])

      if existing_user
        redirect_to user_path(@user), alert: "Account already exists with those credentials."
      else
        @user.update(github_username: auth["info"]["nickname"]) if @user.valid?
        redirect_to user_path(@user), notice: "Connected Github account."
      end
    else
      reset_session
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
    auth = request.env["omniauth.auth"]

    if session[:user_id].present?
      session[:guest] = nil
      @user = UserService.find_user_by_id(session[:user_id])
      existing_user = UserRepository.find_by_su(auth["extra"]["raw_info"]["id"])

      if existing_user
        redirect_to user_path(@user), alert: "Account already exists with those credentials."
      else
        if @user.valid?
          @user.update(spotify_username: auth["extra"]["raw_info"]["id"])
          session[:spotify_access_token] = auth["credentials"]["token"]
          save_random_spotify_playlist(session[:spotify_access_token], @user.spotify_username)
        end
        redirect_to user_path(@user), notice: "Connected Spotify account."
      end
    else
      reset_session
      @user = UserService.spotify_user(auth)

      if @user.valid?
        session[:user_id] = @user.id
        session[:spotify_access_token] = auth["credentials"]["token"]
        save_random_spotify_playlist(session[:spotify_access_token], @user.spotify_username)
        redirect_to games_path
      else
        redirect_to welcome_path, alert: "Login failed."
      end
    end
  end

  private
  def save_random_spotify_playlist(access_token, spotify_username)
    uri = URI.parse("https://api.spotify.com/v1/users/#{spotify_username}/playlists")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer #{access_token}"

    response = http.request(request)
    playlists_data = JSON.parse(response.body)

    if playlists_data["items"].any?
      random_playlist = playlists_data["items"].sample
      session[:spotify_playlist] = random_playlist["id"]
    else
      session[:spotify_playlist] = nil
    end
  end
end
