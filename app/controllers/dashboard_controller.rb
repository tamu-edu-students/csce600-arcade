class DashboardController < ApplicationController
    before_action :require_login, only: [ :show ]

    def show
      # Dummy data to simulate user statistics
      @dummy_dashboard = {
        user_id: 1,
        total_games_played: 950,
        total_games_won: 450,
        last_played: time_ago_in_words(Time.parse("2024-09-27")),
        current_streak: 12,
        longest_streak: 15
      }

      # Dummy data to simulate game history
      @dummy_games = [
        { name: "Spelling Bee", played_on: "2024-09-27", status: "Won", points: 1354 },
        { name: "Wordle", played_on: "2024-09-27", status: "Won", points: 1354 },
        { name: "Letter Boxed", played_on: "2024-09-27", status: "Won", points: 1354 }
      ]
    end

    private
    def time_ago_in_words(from_time)
      distance_in_minutes = ((Time.now - from_time) / 60).to_i

      case distance_in_minutes
      when 0..59
        "#{distance_in_minutes}m ago"  # Minutes ago
      when 60..1439
        "#{distance_in_minutes / 60}h ago"  # Hours ago
      else
        "#{distance_in_minutes / 1440}d ago"  # Days ago
      end
    end
end
