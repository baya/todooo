require 'rails_helper'

RSpec.describe DeleteTodoService, :type => :model do

  it 'delete todo' do
    user = User.create(name: 'user0', email: 'user0@mail.com')
    team = Team.create(creator: user, name: 'team0')
    project_name = 'a project'
    project = Project.create(team: team, creator: user, name: project_name)
    todo_content = 'a todo content'
    todo = Todo.create(content: todo_content, project: project)

    DeleteTodoService.new(user: user,
                          todo: todo
                          ).call

    assert_equal todo.state, Todo::STATE_MAP.fetch(:deleted)
    event = todo.source_events.order('created_at desc').first
    assert_equal event.user, user
    assert_equal event.action, DeleteTodoService::ACTION
    assert_equal event.team, team
    assert_equal event.source, todo
    assert_equal event.resource, project

  end
  
end
