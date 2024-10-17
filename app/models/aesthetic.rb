class Aesthetic < ApplicationRecord
    validates :game_id, presence: true, uniqueness: true
    validates :primary_clr, presence: true
    validates :secondary_clr, presence: true
    validates :font_clr, presence: true
    validates :font, presence: true
end