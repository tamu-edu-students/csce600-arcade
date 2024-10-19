# app/models/user.rb
class User < ApplicationRecord
    has_many :roles, dependent: :destroy
    has_one :settings, dependent: :destroy
end
