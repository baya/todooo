class CreateTeamService

  ACTION = 'create_team'.freeze

  attr_reader :event

  def initialize(data = {})
    @user = data[:user]
    @name = data[:name]
  end

  def call
    transaction do
      team = create_team
      @event = create_event(team)

      team
    end
  end

  private

  def create_team
    Team.create!(creator: @user, name: @name)
  end

  def create_event(team)
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     team,
                  source:   team,
                  resource: team,
                  )
  end


  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

end
