class SettingsController < ApplicationController
  def update
    settings = Settings.find_by(id: settings_params[:id])
    settings.update!(settings_params)
    redirect_to "#", notice: "Roles have been updated to #{settings.roles}"
  end

  private
  def settings_params
    params.permit(:id, roles: [])
  end
end
