class CreateTodoService

  STATE  = Todo::STATE_MAP
  ACTION = 'create_todo'.freeze

  def initialize(data = {})
    @content   = data[:content]
    @user      = data[:user]
    @project   = data[:project]
    @todo_list = data[:todo_list]
    @state     = STATE.fetch(:init)
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
                 content: @content
                 )
  end

  def create_event(todo)
    todo.source_events.create!(user:     @user,
                              resource: @project,
                              action:   ACTION
                              )
  end

  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end
  
end
