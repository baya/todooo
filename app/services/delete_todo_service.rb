class DeleteTodoService

  include TodoTransaction

  ACTION = 'delete_todo'.freeze
  attr_reader :event

  def initialize(data = {})
    @user    = data[:user]
    @todo    = data[:todo]
    @project = @todo.project
    @team    = @project.team
  end

  def call
    transaction do
      delete_todo
      @event = create_event
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

  
end
