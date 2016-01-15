class MembersController < ApplicationController

  def show
    @member = User.find(params[:id])
  end
  
end
