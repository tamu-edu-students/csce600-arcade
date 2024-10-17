class Settings < ApplicationRecord
  serialize :roles, type: Array, coder: JSON

  belongs_to :user
end
