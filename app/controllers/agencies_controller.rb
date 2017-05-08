class AgenciesController < ApplicationController
  layout false

  def index
    @agencies = Agency.all
    respond_to do |format|
      format.html {}
      format.json { render :json => @agencies }
    end
  end

end
