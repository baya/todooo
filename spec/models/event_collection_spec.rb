# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe EventCollection, :type => :model do

  it 'to_group_data, 动态以创建时间倒序排列, 并且相邻的动态件如果属于同一类，则规划到一类中' do
    tday = DateTime.now.to_date
    user = User.create(name: 'a user', email: 'auser@mail.com')
    team_name = 'a team'
    project_name = 'a project'
    team = CreateTeamService.new(user: user, name: team_name).call
    project = CreateProjectService.new(user: user, team: team, name: project_name).call
    todo_content = 'a todo content'
    todo = CreateTodoService.new(user: user,
                                 project: project,
                                 content: todo_content
                                 ).call
    DeleteTodoService.new(user: user, todo: todo).call

    group_data = EventCollection.create(team_id: team.id).to_group_data
    cates = group_data[tday]

    assert_equal cates.size, 2
    assert_equal cates[0].name, project_name
    assert_equal cates[0].items.map(&:action), [DeleteTodoService::ACTION,
                                                CreateTodoService::ACTION,
                                                CreateProjectService::ACTION
                                               ]

    assert_equal cates[1].name, team_name
    assert_equal cates[1].items.map(&:action), [CreateTeamService::ACTION]
  end
  
end
