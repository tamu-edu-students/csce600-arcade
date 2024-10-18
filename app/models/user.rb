# app/models/user.rb
class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    has_many :roles, dependent: :destroy # 1 user can have many roles
end
