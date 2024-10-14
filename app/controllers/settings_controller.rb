class SettingsController < ApplicationController
  def update
    settings = Settings.find_by(id: settings_params[:id])
    settings.update!(settings_params)
    flash[:notice] = "Roles have been updated to #{settings.roles.join(', ')}"
    redirect_to user_path(@current_user)
  end

  private
  def settings_params
    params.permit(:id, roles: [])
  end
end
