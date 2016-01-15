class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_team

  def current_team
    @current_team ||= Team.find_by(id: session[:team_id])
  end

  def current_team=(team)
    @current_team = team
    session[:team_id] = team.id
  end
  
end
