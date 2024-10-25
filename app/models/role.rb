class Role < ActiveRecord::Base
  validates :role, presence: true, inclusion: {
    in: [ "System Admin", "Puzzle Aesthetician", "Puzzle Setter", "Member" ],
    message: "%{value} is not a valid role"
  }

  belongs_to :user
  belongs_to :game, optional: true

  def self.all_roles
    [ "System Admin", "Puzzle Aesthetician", "Puzzle Setter", "Member" ]
  end

  def self.game_roles
    [ "Puzzle Aesthetician", "Puzzle Setter" ]
  end

  def self.role_color(role)
    map = {
      "System Admin" => "rgba(255, 0, 0, 0.35);",
      "Wordle" => "rgba(0, 128, 0, 0.4)",
      "Spelling Bee" => "rgba(255, 217, 0, 0.4)",
      "Letter Boxed" => "rgba(255, 217, 0, 0.4)"
    }
    map[role]
  end
end
