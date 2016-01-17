require 'rails_helper'

RSpec.describe CreateTodoService, :type => :model do

  it 'create todo' do
    user = User.create(name: 'user0', email: 'user0@mail.com')
    team = Team.create(creator: user, name: 'team0')
    project_name = 'a project'
    project = Project.create(team: team, creator: user, name: project_name)
    todo_content = 'a todo content'

    todo = CreateTodoService.new(user: user,
                                 content: todo_content,
                                 project: project
                                 ).call

    assert_equal todo.creator, user
    assert_equal todo.content, todo_content
    assert_equal todo.state, Todo::STATE_MAP.fetch(:init)
    assert_equal todo.project, project

    event = todo.source_events.order('created_at desc').first
    assert_equal event.user, user
    assert_equal event.action, CreateTodoService::ACTION
    assert_equal event.team, team
    assert_equal event.source, todo
    assert_equal event.resource, project

  end
  
end
