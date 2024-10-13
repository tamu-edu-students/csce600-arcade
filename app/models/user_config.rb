class UserConfig < ApplicationRecord
  serialize :roles, Array

  belongs_to :user
end
