require 'rails_helper'

RSpec.describe CreateTeamService, :type => :model do

  it 'create team' do
    user = User.create(name: 'user0', email: 'user0@mail.com')
    team_name = 'a team'
    team = CreateTeamService.new(user: user, name: team_name).call

    assert_equal team.creator, user
    assert_equal team.name, team_name
    event = team.source_events.order('created_at desc').first
    assert_equal event.user, user
    assert_equal event.action, CreateTeamService::ACTION
    assert_equal event.team, team
    assert_equal event.source, team
    assert_equal event.resource, team
  end
end
