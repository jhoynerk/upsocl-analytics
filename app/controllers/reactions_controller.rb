class ReactionsController < ApplicationController
  layout false

  def index
    @reactions = Reaction.all
    respond_to do |format|
      format.html {}
      format.json { render :json => @reactions }
    end
  end

  def data_reactions
    @url = Url.where(data: params[:url]).first
    if(@url.nil?)
      response = { msg: 'No existe esta ruta'}
    else
      response = @url.count_votes
    end
    respond_to do |format|
      format.html {}
      format.json { render :json => response }
    end
  end

end
