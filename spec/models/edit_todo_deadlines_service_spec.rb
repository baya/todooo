require 'rails_helper'

RSpec.describe EditTodoDeadlinesService, :type => :model do

  before do
    @user = User.create(name: 'user0', email: 'user0@mail.com')
    @team = Team.create(creator: @user, name: 'team0')
    @project = Project.create(team: @team, creator: @user, name: 'project0')
    @todo = Todo.create(content: 'todo 01', project: @project)
  end

  it 'no deadlines, edit todo deadlines' do
    new_deadlines = '2016-02-13'
    EditTodoDeadlinesService.new(user: @user,
                                 todo: @todo,
                                 new_deadlines: new_deadlines
                                 ).call

    assert_equal @todo.deadlines, new_deadlines.to_date
    
    event = @todo.source_events.order('created_at desc').first
    assert_equal event.user, @user
    assert_equal event.action, EditTodoDeadlinesService::ACTION
    assert_equal event.team, @team
    assert_equal event.source, @todo
    assert_equal event.resource, @project
    assert_equal event.old_deadlines, nil
    assert_equal event.new_deadlines, new_deadlines.to_date
  end

  it 'has deadlines, edit todo deadlines' do
    old_deadlines = '2016-01-29'
    new_deadlines = '2016-02-13'
    @todo.deadlines = old_deadlines
    @todo.save
    
    EditTodoDeadlinesService.new(user: @user,
                                 todo: @todo,
                                 new_deadlines: new_deadlines
                                 ).call

    assert_equal @todo.deadlines, new_deadlines.to_date
    
    event = @todo.source_events.order('created_at desc').first
    assert_equal event.user, @user
    assert_equal event.action, EditTodoDeadlinesService::ACTION
    assert_equal event.team, @team
    assert_equal event.source, @todo
    assert_equal event.resource, @project
    assert_equal event.old_deadlines, old_deadlines.to_date
    assert_equal event.new_deadlines, new_deadlines.to_date
  end

  
end
