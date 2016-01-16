class DeleteTodoService

  STATE  = Todo::STATE_MAP
  ACTION = 'delete_todo'.freeze

  def initialize(data = {})
    @user    = data[:user]
    @todo    = data[:todo]
    @project = @todo.project
    @team    = @project.team
  end

  def call
    transaction do
      delete_todo
      create_event
    end
  end

  private

  def delete_todo
    @todo.state = STATE.fetch(:deleted)
    @todo.save!
  end

  def create_event
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   @todo,
                  resource: @project,
                  )
  end

  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  
end
