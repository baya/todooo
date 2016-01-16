class EditAssignTodoService

  include TodoTransaction

  ACTION = 'edit_assign_todo'.freeze

  def initialize(data = {})
    @user              = data[:user]
    @todo              = data[:todo]
    @new_assigned_user = data[:new_assigned_user]
    @old_assigned_user = @todo.assigned_user
    @project           = @todo.project
    @team              = @project.team
  end

  def call
    check_todo_state(:edit_assign)
    transaction do
      edit_assign_todo
      create_event
    end
  end

  private

  def edit_assign_todo
    @todo.assigned_user = @new_assigned_user
    @todo.save!
  end

  def create_event
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   @todo,
                  resource: @project,
                  new_assigned_user_id: @new_assigned_user.id,
                  old_assigned_user_id: @old_assigned_user.id
                  )
  end

end
