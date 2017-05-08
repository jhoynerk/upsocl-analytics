class UsersController < ApplicationController
  layout false

  def index
    @users = User.all
    respond_to do |format|
      format.html {}
      format.json { render :json => @users }
    end
  end

end
