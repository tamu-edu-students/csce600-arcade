class UserConfig < ApplicationRecord
  serialize :roles, Array
end
