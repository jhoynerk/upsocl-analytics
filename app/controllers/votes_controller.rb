class VotesController < ApplicationController
  respond_to :json

  def create
    @url = Url.where(data: params[:url_path])
    unless @url.nil?
      @url = @url.first
      @url.votes << Vote.new(url_id: @url.id, reaction_id: params[:reaction_id])
      @url.save
      response = @url.count_votes
    end
    respond_to do |format|
      format.json { render :json => response }
    end
  end

  def change_vote
    @url = Url.where(data: params[:url_path])
    unless @url.nil?
      @url = @url.first
      @url.remove_vote(params[:before_vote])
      @url.votes << Vote.new(url_id: @url.id, reaction_id: params[:reaction_id])
      @url.save
      response = @url.count_votes
    end
    respond_to do |format|
      format.json { render :json => response }
    end
  end
end
