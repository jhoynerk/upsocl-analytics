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
    if(@url.nil?)
      if(params[:publico].present?)
        url = Url.create(line_id: 0, data: params[:url], publico: true)
        response = url.count_votes
      else
        response = { msg: 'No existe esta ruta'} 
      end
    else
      response = @url.count_votes
    end
    respond_to do |format|
      format.html {}
      format.json { render :json => response }
    end
  end

end
