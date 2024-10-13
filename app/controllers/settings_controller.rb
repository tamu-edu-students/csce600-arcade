class SettingsController < ApplicationController
  def update
    config = Settings.find_by(user_id: @current_user.id)
    config.update!(config_params)
    redirect_to user_path(@current_user), notice: "Roles have been updated to #{config.roles}"
  end

  private
  def config_params
    params.permit(roles: [])
  end
end
