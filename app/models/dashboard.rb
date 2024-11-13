# This model holds the statistics for each user's gaming history.
# It allows a user to track their progress and history for each game.
# Each user has a special "streak record" with game_id of -1 to track combined data for streak computations
#
# @attr [Integer] user_id The user for whom the record is. Foreign key referenced to the associated `User` model
# @attr [Integer] game_id The game for which the record is. Foreign key referenced to the associated `Game` model. Id is -1 for streak record
# @attr [Date] played_on The date on which the user played the game referenced in this entry
# @attr [Integer] score The score the user attained playing the game on the specific date
# @sttr [Boolean] streak_record Specifies whether this is the users aggregate streak record or not
# @attr [Integer] streak_count The highest streak tracking consecutive days game played by user. Only set when streak_record is true
#
# @raise [ValidationError] if an attempt to change the streak record to a non steak record is done after record creation
class Dashboard < ApplicationRecord
  validate :streak_record_cannot_be_changed, on: :update

  private

  def streak_record_cannot_be_changed
    if streak_record_changed? && streak_record_was.present?
      errors.add(:streak_record, "cannot be modified once set")
    end
  end
end
