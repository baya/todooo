# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  before do
    user = User.create(name: 'a user', email: 'auser@mail.com')
    @team_name = 'a team'
    @project_name = 'a project'
    @team = CreateTeamService.new(user: user, name: @team_name).call
    project = CreateProjectService.new(user: user, team: @team, name: @project_name).call
    @todo_content = 'a todo content'
    todo = CreateTodoService.new(user: user,
                                 project: project,
                                 content: @todo_content
                                 ).call
    DeleteTodoService.new(user: user, todo: todo).call
  end

  describe 'GET index' do
    render_views
    
    it 'html, 返回分组的动态内容' do
      get 'index', team_id: @team.id

      assert response.body.include?('今')
      assert response.body.include?(@team_name)
      assert response.body.include?(@project_name)
      assert response.body.include?(@todo_content)
    end

    it 'json, 返回分组动态数据' do
      get 'index', format: 'json', team_id: @team.id

      data = JSON.parse(response.body)
      tday = DateTime.now.strftime('%Y-%m-%d')
      assert data.key?(tday)
      cate = data[tday][0]
      assert_equal cate['name'], @project_name
    end
  end
  
end
