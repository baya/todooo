class EventsController < ApplicationController

  def index
    @team = Team.find(params[:team_id])
    collection = EventCollection.create(params)
    
    respond_to do |format|
      format.html do
        self.current_team = @team
        @event_group = collection.to_group_data
        @days = @event_group.keys.sort {|x, y| y <=> x}
      end
      format.json do
        render json: collection.to_hash_group_data
      end
    end
  end
  
end
