# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    before do
        User.destroy_all
    end
    let(:user) do 
        User.create(first_name: 'Test', last_name: 'User', email: 'test@example.com', uid: '1')
        
    end
    before do
    session[:user_id] = user.id
    end
end