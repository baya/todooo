class ProjectsController < ApplicationController

  def index
    @team = Team.find(params[:team_id])
  end

  def show
    @team    = Team.find(params[:team_id])
    @project = Project.find(params[:id])
  end
  
end
