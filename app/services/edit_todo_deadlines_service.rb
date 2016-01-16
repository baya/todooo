class EditTodoDeadlinesService

  include TodoTransaction

  ACTION = 'edit_todo_deadlines'.freeze

  def initialize(data = {})
    @user          = data[:user]
    @todo          = data[:todo]
    @new_deadlines = data[:new_deadlines]
    @old_deadlines = @todo.deadlines
    @project       = @todo.project
    @team          = @project.team
  end

  def call
    transaction do
      edit_todo_deadlines
      create_event
    end
  end
  

  private

  def edit_todo_deadlines
    @todo.deadlines = @new_deadlines
    @todo.save!
  end

  def create_event
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   @todo,
                  resource: @project,
                  old_deadlines: @old_deadlines,
                  new_deadlines: @new_deadlines
                  )
  end


end
