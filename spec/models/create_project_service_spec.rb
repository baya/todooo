require 'rails_helper'

RSpec.describe CreateProjectService, :type => :model do

  it 'create project' do
    user = User.create(name: 'user0', email: 'user0@mail.com')
    team = Team.create(creator: user, name: 'team0')
    project_name = 'a project'

    project = CreateProjectService.new(user: user,
                                       team: team,
                                       name: project_name
                                       ).call

    assert_equal project.name, project_name
    assert_equal project.creator, user
    assert_equal project.team, team
    event = project.source_events.order('created_at desc').first
    assert_equal event.user, user
    assert_equal event.action, CreateProjectService::ACTION
    assert_equal event.team, team
    assert_equal event.source, project
    assert_equal event.resource, project

  end
  
end
