class TeamsController < ApplicationController

  def show
    @team = Team.find(params[:id])
    redirect_to team_projects_path(@team.id)
  end
  
end
