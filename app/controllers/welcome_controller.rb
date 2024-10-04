class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [ :index, :guest]

  def index
    if logged_in?
      redirect_to games_path, notice: "Welcome, back!"
    else
      render "index"
    end
  end

  def guest
    session[:guest] = true
    redirect_to games_path
  end
end
