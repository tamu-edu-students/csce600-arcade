class RolesController < ApplicationController
  # before_action :check_session_id_admin, only: %i[ index ]
  def index
    if params[:user_id].nil?
      redirect_to games_path
    else
      @managing_user ||= User.find(params[:user_id])
    end
  end

  def destroy
    @managing_user = User.find(params[:user_id])
    if params[:id] == "destroy_many"
      role = Role.where(role: params[:role], user_id: @managing_user.id).destroy_all
      SettingsService.remove_role(@managing_user, params[:role], "any")
    else
      role = Role.find(params[:id])
      SettingsService.remove_role(@managing_user, role.role, role.game ? role.game.name : "")
      role.destroy!
    end
    redirect_to roles_path(user_id: @managing_user.id), notice: "Removed role from user"
  end

  def create
    @managing_user = User.find(params[:user_id])
    if params[:game]
      game = Game.find_by(name: params[:game])
      Role.create!(role: params[:role], user_id: @managing_user.id, game_id: game.id)
    else
      Role.create!(role: params[:role], user_id: @managing_user.id)
    end
    redirect_to roles_path(user_id: @managing_user.id), notice: "Assigned role to user"
  end
end
