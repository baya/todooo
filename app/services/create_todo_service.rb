class CreateTodoService

  STATE  = Todo::STATE_MAP
  ACTION = 'create_todo'.freeze

  def initialize(data = {})
    @content   = data[:content]
    @user      = data[:user]
    @project   = data[:project]
    @todo_list = data[:todo_list]
    @state     = STATE.fetch(:init)
    @team      = @project.team
  end

  def call
    transaction do
      todo = create_todo
      create_event(todo)
    end
  end

  def create_todo
    Todo.create!(creator: @user,
                 project: @project,
                 state:   @state,
                 content: @content,
                 )
  end

  def create_event(todo)
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   todo,
                  resource: @project,
                  )
  end

  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
  
end