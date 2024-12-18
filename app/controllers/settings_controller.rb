class SettingsController < ApplicationController
  def update_settings
    if session[:guest].present?
      render json: { success: false }, status: 401
      return
    end
    settings = Settings.find_by(user_id: session[:user_id])
    if params[:settings].present? and !params[:settings][:game_font_casing].nil?
      settings.game_font_casing = params[:settings][:game_font_casing]
    end

    if params[:settings].present? and !params[:settings][:page_contrast].nil?
      settings.page_contrast = params[:settings][:page_contrast]
    end

    if params[:settings].present? and params[:settings][:active_roles].present?
      settings.active_roles = params[:settings][:active_roles].join(",")
    end

    if params[:settings].present? and !params[:settings][:active_roles].nil? and params[:settings][:active_roles].empty?
      settings.active_roles = ""
    end

    settings.save

    render json: { success: true }, status: 200
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
