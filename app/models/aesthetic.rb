class Aesthetic < ApplicationRecord
    validates :game_id, presence: true, uniqueness: true
end