require 'rails_helper'

RSpec.describe EditAssignTodoService, :type => :model do

  before do
    @user0 = User.create(name: 'user0', email: 'user0@mail.com')
    @team0 = Team.create(creator: @user0, name: 'team0')
    @user1 = User.create(name: 'user1', email: 'user1@mail.com')
    @project0 = Project.create(team: @team0, creator: @user0, name: 'project0')
    @todo = Todo.create(content: 'todo 01', project: @project0, assigned_user: @user1)
    @user2 = User.create(name: 'user2', email: 'user2@mail.com')
  end

  it 'edit assign todo' do
    EditAssignTodoService.new(user: @user0,
                              todo: @todo,
                              new_assigned_user: @user2
                              ).call

    assert_equal @todo.assigned_user, @user2

    event = @todo.source_events.order('created_at desc').first
    assert_equal event.user, @user0
    assert_equal event.action, EditAssignTodoService::ACTION
    assert_equal event.team, @team0
    assert_equal event.source, @todo
    assert_equal event.resource, @project0
    assert_equal event.new_assigned_user_id, @user2.id
    assert_equal event.old_assigned_user_id, @user1.id
  end
  
end
