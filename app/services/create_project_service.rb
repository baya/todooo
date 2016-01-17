class CreateProjectService

  ACTION = 'create_project'.freeze

  def initialize(data = {})
    @user = data[:user]
    @team = data[:team]
    @name = data[:name]
  end

  def call
    transaction do
      project = create_project
      create_event(project)

      project
    end
  end

  private

  def create_project
    Project.create!(creator: @user, team: @team, name: @name)
  end

  def create_event(project)
    Event.create!(user:     @user,
                  action:   ACTION,
                  team:     @team,
                  source:   project,
                  resource: project,
                  )
  end


  def transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  
end
