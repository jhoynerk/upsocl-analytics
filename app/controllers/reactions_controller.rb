class ReactionsController < ApplicationController
  layout false

  def index
    @reactions = Reaction.all.order(:order)
    respond_to do |format|
      format.html {}
      format.json { render :json => @reactions }
    end
  end

  def data_reactions
    @url = Url.where(data: params[:url]).first
    response = (@url.present?) ? @url.count_votes : { msg: 'No existe esta ruta'}
    respond_to do |format|
      format.html {}
      format.json { render :json => response }
    end
  end

end
