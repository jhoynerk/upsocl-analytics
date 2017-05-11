class UrlsController < ApplicationController
  layout false
  def show
    @url = Url.find(params[:id]).decorate
    @url.params = { :start_date => params[:startDate]&.to_time, :end_date => params[:endDate]&.to_time }
    render_to_app
  end

  def update_stadistics
    @url = Url.find(params[:id]).decorate
    @url.update_stadistics
    render_to_app
  end

  def render_to_app
    respond_to do |format|
      format.html {}
      format.json { render :json => @url.as_json( methods: [ :tags, :tag_names, :campaign, :social_count, :stadistics, :totals_stadistics, :next_url, :previous_url, :count_votes, :fb_posts_totals ]) }
    end
  end

end
