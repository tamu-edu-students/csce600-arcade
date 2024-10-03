# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def show
    @current_user = UserService.find_user_by_id(params[:id])
  end
end
