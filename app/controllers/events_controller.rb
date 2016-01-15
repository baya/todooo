class EventsController < ApplicationController

  def index
    @team        = Team.find(params[:team_id])
    @event_group = EventCollection.create_group_data(params)
    @days = @event_group.keys.sort
  end
  
end
