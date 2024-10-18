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
    settings.roles = submitted_role_ids

    if settings.save
      flash[:notice] = "Active Roles were updated"
    else
      flash[:alert] = "Failed to update roles."
    end
  
    redirect_to user_path(@current_user)



    # @settings = Settings.find_by(id: settings_params[:id])
    
    # # Handle case when settings not found
    # if @settings.nil?
    #   flash[:alert] = "Settings not found"
  #   redirect_to user_path(@current_user) and return
    # end

    # @settings.roles.clear # Remove existing roles

    # # Get new roles submitted in the form
    # if params[:settings].nil?
    #   flash[:alert] = "No roles were selected"
    #   redirect_to user_path(@current_user) and return
    # end

    # submitted_role_ids = params[:settings][:role_ids]
    # # Convert to integers for comparison
    # submitted_role_ids = submitted_role_ids.map(&:to_i)

    # # Role objects for the role ids submitted
    # submitted_role_objects = Role.where(id: submitted_role_ids)

    # submitted_role_list = submitted_role_objects.map do |role|
    #   if ["Puzzle Setter", "Puzzle Aesthetician"].include?(role.role) && role.game.present?
    #     "#{role.role} for #{role.game.name}"
    #   else
    #     role.role
    #   end
    # end

    # # puts "HERE : #{@settings.inspect}"
    # @settings.roles = submitted_role_list
    # flash[:notice] = "Roles have been updated"
    # redirect_to user_path(@current_user)
  end

  private

  def settings_params
    params.permit(:id, settings: { role_ids: [] })
  end
end
