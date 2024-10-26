# app/services/dashboard_service.rb
class DashboardService
    def initialize(user_id, game_id, score)
      @user_id = user_id
      @game_id = game_id
      @score = score
    end
  
    def call
      most_recent_stats = Dashboard.where(user_id: @user_id, game_id: @game_id)
                                   .order(played_on: :desc)
                                   .first
  
      if most_recent_stats.nil? || most_recent_stats.played_on == Date.yesterday
        update_streak
      end
  
      if most_recent_stats.nil? || most_recent_stats.played_on < Date.today
        Dashboard.create!(user_id: @user_id, game_id: @game_id, played_on: Date.today, score: @score)
      end
    end
  
    private
  
    def update_streak
      streak_record = Dashboard.find_or_initialize_by(user_id: @user_id, game_id: -1, streak_record: true)
      streak_record.streak_count += 1
      streak_record.save
    end
  end
  