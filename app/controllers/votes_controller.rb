class VotesController < ApplicationController
  respond_to :json

  def create
    @url = Url.where(data: params[:url_path]).first
    if(@url.nil?)

    else
      @url.votes << Vote.new(url_id: @url.id, reaction_id: params[:reaction_id])
      @url.save
    end
    response = @url.count_votes
    respond_to do |format|
      format.json { render :json => response }
    end
  end
end
