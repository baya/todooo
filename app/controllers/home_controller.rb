class HomeController < ApplicationController

  layout 'home'

  def index
    @teams = Team.order('created_at desc')
  end
  
end
