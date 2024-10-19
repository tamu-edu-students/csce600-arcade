# app/models/user.rb
class User < ApplicationRecord
    has_many :roles, dependent: :destroy # 1 user can have many roles
end
