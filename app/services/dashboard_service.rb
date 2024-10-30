# app/services/dashboard_service.rb
class DashboardService
    def initialize(user_id, game_id, score)
      @user_id = user_id
      @game_id = game_id
      @score = score
    end
  
    def call
      most_recent_stats = Dashboard.where(user_id: @user_id).order(played_on: :desc).first
      streak_record = Dashboard.find_or_initialize_by(user_id: @user_id, game_id: -1, streak_record: true)
      if most_recent_stats.nil?
        streak_record.streak_count = 1
      elsif most_recent_stats.played_on == Date.yesterday
        streak_record.streak_count += 1
      elsif most_recent_stats.played_on < Date.yesterday
        streak_record.streak_count = 1
      end
      streak_record.save

      today_record = Dashboard.find_by(user_id: @user_id, game_id: @game_id, played_on: Date.today)

      if single_score_per_day?
        Dashboard.create!(user_id: @user_id, game_id: @game_id, played_on: Date.today, score: @score) if today_record.nil?
      elsif !single_score_per_day? and today_record
        today_record.update!(score: today_record.score + @score)
      else
        Dashboard.create!(user_id: @user_id, game_id: @game_id, played_on: Date.today, score: @score)
      end
    end
    
    private
    def single_score_per_day?
      Game.find(@game_id).single_score_per_day?
    end
  end
  