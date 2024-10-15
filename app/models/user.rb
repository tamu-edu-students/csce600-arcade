# app/models/user.rb
class User < ApplicationRecord
    has_one :role, dependent: :destroy
end
