class ApplicationController < ActionController::Base
  before_action :require_login
  # rescue_from StandardError, with: :handle_standard_error

  private

  def current_user
    # if @current _user is undefined or falsy, evaluate the RHS
    #   RHS := look up user by id only if user id is in the session hash
    # question: what happens if session has user_id but DB does not?
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # current_user returns @current_user,
    #   which is not nil (truthy) only if session[:user_id] is a valid user id
    current_user
  end

  def require_login
    # redirect to the welcome page unless user is logged in
    unless logged_in? || session[:guest]
      redirect_to welcome_path, alert: "You must be logged in or a guest to access this section."
    end
  end

  def handle_standard_error(exception)
    logger.error(exception.message)
    reset_session
    redirect_to welcome_path, alert: "An unexpected error occured. Please contact administrator if issue persists."
  end
end
