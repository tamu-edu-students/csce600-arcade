class SettingsController < ApplicationController
  def update
    # Clear existing roles
    if not session[:user_id].nil?
      settings = Settings.find_by(user_id: session[:user_id])
      settings.roles.clear
    end
    # Get new roles submitted in the form
    if params[:settings].nil?
      flash[:alert] = "No roles were selected"
      redirect_to user_path(@current_user) and return
    end

    submitted_role_ids = params[:settings][:role_ids]
    puts "HERE in settings : #{submitted_role_ids.inspect}"
    # Update roles in Settings for this user
    settings.roles = submitted_role_ids.map { |s| s.to_i }

    if settings.save
      flash[:notice] = "Active Roles were updated"
    else
      flash[:alert] = "Failed to update roles."
    end

    redirect_to user_path(@current_user)
  end

  private

  def settings_params
    params.permit(:id, settings: { role_ids: [] })
  end
end
