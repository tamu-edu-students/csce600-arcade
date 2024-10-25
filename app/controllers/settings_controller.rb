class SettingsController < ApplicationController
  def update_wordle_settings
    puts params
    settings = Settings.find_by(user_id: session[:user_id])
    if params[:settings].present? and !params[:settings][:wordle_upper_casing].nil?
      settings.wordle_upper_casing = params[:settings][:wordle_upper_casing]
    else
      settings.wordle_upper_casing = true
    end
    settings.save
  end

  def update
    settings = Settings.find_by(user_id: session[:user_id])
    if params[:settings].present? and params[:settings][:active_roles].present?
      settings.active_roles = params[:settings][:active_roles].join(",")
    else
      settings.active_roles = ""
    end

    settings.save
    redirect_to user_path(User.find_by(id: session[:user_id])), notice: "Active roles updated."
  end
end
