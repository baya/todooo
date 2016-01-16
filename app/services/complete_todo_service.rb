# -*- coding: utf-8 -*-
class CompleteTodoService

  include TodoTransaction

  ACTION = 'complete_todo'.freeze

  def initialize(data = {})
    @user    = data[:user]
    @todo    = data[:todo]
    @project = @todo.project
    @team    = @project.team
  end

  def call
    check_todo_state(:complete)
    transaction do
      complete_todo
      create_event
    end
  end

  private

  def complete_todo
    @todo.state = STATE.fetch(:completed)
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
