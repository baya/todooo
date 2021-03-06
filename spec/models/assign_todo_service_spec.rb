# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe AssignTodoService, :type => :model do

  it '为 todo 分配完成者' do
    user0 = User.create(name: 'user0', email: 'user0@mail.com')
    team0 = Team.create(creator: user0, name: 'team0')
    user1 = User.create(name: 'user1', email: 'user1@mail.com')
    project0 = Project.create(team: team0, creator: user0, name: 'project0')
    todo = Todo.create(content: 'todo 01', project: project0)

    AssignTodoService.new(user: user0,
                          assigned_user: user1,
                          todo: todo
                          ).call

    assert_equal todo.assigned_user, user1
    event = todo.source_events.order('created_at desc').first
    assert_equal event.action, AssignTodoService::ACTION
    assert_equal event.user, user0
    assert_equal event.resource, project0
    assert_equal event.source, todo
    assert_equal event.new_assigned_user_id, user1.id
  end

  
end
