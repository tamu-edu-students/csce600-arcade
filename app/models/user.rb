# app/models/user.rb
class User < ApplicationRecord
    validates :uid, presence: true, uniqueness: true
    has_one :role, dependent: :destroy
end
