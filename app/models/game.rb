class Game < ApplicationRecord
  validates :name, presence: true

  has_one :aesthetic
  has_many :roles
end
