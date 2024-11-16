# Handles tracking user specific gaming history and statistics
class DashboardController < ApplicationController
    before_action :require_login, only:  %i[ show ]

    # This method sets the dashboard details displayed to the user.
    #
    # Sets the following attributes aggregated for all games:
    # total_games_played, last_played_on, streak.
    #
    # Sets the following attributes for each game:
    # name, last_played_on, score
    def show
      @dashboard_details = {}

      populate_total_games_played
      populate_last_played_on
      populate_streak
      populate_game_stats
    end

    # This method sets the game history displayed to the user.
    def game_history
      @game = Game.find(params[:game_id])
      @game_history = Dashboard.where(user_id: session[:user_id], game_id: @game.id).order(played_on: :desc)
    end

    private
    def populate_streak
      streak_record = Dashboard.where(user_id: session[:user_id], game_id: -1, streak_record: true).first
      @dashboard_details["streak"] = streak_record&.streak_count || 0
    end

    def populate_last_played_on
      last_played_record = Dashboard.where(user_id: session[:user_id]).where.not(game_id: -1).order(played_on: :desc).first
      @dashboard_details["last_played_on"] = time_ago_in_words(last_played_record&.played_on)
    end

    def populate_total_games_played
      @dashboard_details["total_games_played"] = Dashboard.where(user_id: session[:user_id]).where.not(game_id: -1).count
    end

    def populate_game_stats
      games = Game.where.not(id: -1)
      games.each do |game|
        last_played_record = Dashboard.where(user_id: session[:user_id], game_id: game.id).order(played_on: :desc).first
        @dashboard_details[game.id] = {
          "name" => game.name,
          "last_played_on" => time_ago_in_words(last_played_record&.played_on),
          "score" => Dashboard.where(user_id: session[:user_id], game_id: game.id).sum(:score)
         }
      end
    end

    def time_ago_in_words(from_time)
      return "Never played" if from_time.nil?  # Handle nil input

      # Calculate distance in days
      distance_in_days = (Date.today - from_time).to_i

      if distance_in_days < 1
        "today"  # Less than a day
      else
        "#{distance_in_days} days ago"  # Days ago
      end
    end
end
