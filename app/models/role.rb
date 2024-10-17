class Role < ActiveRecord::Base
  validates :role, presence: true, inclusion: {
    in: [ "System Admin", "Puzzle Aesthetician", "Puzzle Setter", "Member" ],
    message: "%{value} is not a valid role"
  }

  belongs_to :user
  belongs_to :game, optional: true # This makes the game association optional

  # Class method to return all valid roles
  def self.all_roles
    ["System Admin", "Puzzle Aesthetician", "Puzzle Setter", "Member"]
  end
  
end
