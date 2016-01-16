class AssignTodoService
  
  include TodoTransaction

  ACTION = 'assign_todo'.freeze

  def initialize(data = {})
    @user          = data[:user]
    @assigned_user = data[:assigned_user]
    @todo          = data[:todo]
    @project       = @todo.project
    @team          = @project.team
  end

  def call
    check_todo_state(:assign)
    transaction do
      assign_todo
      create_event
    end
  end
  

  private

  def assign_todo
    @todo.assigned_user = @assigned_user
    @todo.save!
  end

  def create_event
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   @todo,
                  resource: @project,
                  new_assigned_user_id: @assigned_user.id
                  )
  end

end
