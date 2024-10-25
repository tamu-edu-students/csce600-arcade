class Aesthetic < ApplicationRecord
    validates :game_id, presence: true, uniqueness: true
    validates :colors, presence: true
    validates :font, presence: true

    belongs_to :game
end
