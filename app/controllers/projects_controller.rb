class ProjectsController < ApplicationController

  def show
    @team   = Team.find(params[:team_id])
    @project = Project.find(params[:id])
  end
  
end
