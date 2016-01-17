class CreateTodoService

  include TodoTransaction

  ACTION = 'create_todo'.freeze

  attr_reader :event

  def initialize(data = {})
    @content   = data[:content]
    @user      = data[:user]
    @project   = data[:project]
    @todo_list = data[:todo_list]
    @team      = @project.team
  end

  def call
    transaction do
      todo = create_todo
      @event = create_event(todo)

      todo
    end
  end

  private

  def create_todo
    Todo.create!(creator: @user,
                 project: @project,
                 state:   STATE.fetch(:init),
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

end
