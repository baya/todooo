# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe CompleteTodoService, :type => :model do

  it '完成 todo' do
    user0 = User.create(name: 'user0', email: 'user0@mail.com')
    team0 = Team.create(creator: user0, name: 'team0')
    user1 = User.create(name: 'user1', email: 'user1@mail.com')
    project0 = Project.create(team: team0, creator: user0, name: 'project0')
    todo = Todo.create(content: 'todo 01', project: project0)

    CompleteTodoService.new(user: user0,
                            todo: todo
                            ).call

    assert_equal todo.state, Todo::STATE_MAP.fetch(:completed)
    event = todo.source_events.order('created_at desc').first
    assert_equal event.user, user0
    assert_equal event.action, CompleteTodoService::ACTION
    assert_equal event.team, team0
    assert_equal event.source, todo
    assert_equal event.resource, project0

  end
  
end
