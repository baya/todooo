class TodosController < ApplicationController

  def show
    @project = Project.find(params[:project_id])
    @todo = Todo.find(params[:id])
  end
  
end
