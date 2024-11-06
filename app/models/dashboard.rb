class Dashboard < ApplicationRecord
  validate :streak_record_cannot_be_changed, on: :update

  private

  def streak_record_cannot_be_changed
    if streak_record_changed? && streak_record_was.present?
      errors.add(:streak_record, "cannot be modified once set")
    end
  end
end
