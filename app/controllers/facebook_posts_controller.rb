class FacebookPostsController < ApplicationController
  layout false
  def show
    @url = FacebookPost.find(params[:id]).decorate
    render_to_app
  end

  def show_view
    render :show
  end

  def update_stadistics
    @url = FacebookPost.find(params[:id]).decorate
    @url.update_stadistics
    render_to_app
  end

  private
  def render_to_app
    respond_to do |format|
      format.html {}
      format.json { render json: @url.as_json( methods: [ :tags, :tag_names, :campaign, :stadistics, :totals_stadistics, :next_url, :previous_url, :count_votes ]) }
    end
  end
end
