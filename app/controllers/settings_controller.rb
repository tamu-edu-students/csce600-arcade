class SettingsController < ApplicationController
  def update
    settings = Settings.find_by(user_id: session[:user_id])
    if params[:settings].present?
      settings.active_roles = params[:settings][:active_roles].join(",")
    else
      settings.active_roles = ""
    end
    settings.save
    redirect_to user_path(User.find_by(id: session[:user_id])), notice: "Active roles updated."
  end
end
