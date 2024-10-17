class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [ :index, :guest ]

  def index
    if logged_in?
      redirect_to games_path
    elsif session[:guest]
      redirect_to games_path
    else
      render "index"
    end
  end

  def guest
    session[:guest] = true
    session[:htp_sb] = true
    redirect_to games_path
  end
end
