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
      format.json { render :json => @url.as_json( methods: [ :tags, :tag_names, :campaign, :stadistics, :totals_stadistics, :next_url, :previous_url, :count_votes, :fb_posts_totals ]) }
    end
  end

  def filter_by_tag
    @urls_filtered = Url.search(params)
    @urls = UrlsDecorator.new(@urls_filtered.order(:title).page(params[:paginate_page]).per(params[:paginate_regs]))
    respond_to do |format|
      format.html {}
      format.json {
        render json:{
          urls: @urls.as_json(
            methods: [ :goal_status ],
            include: {
              campaign: { include: { users: { only: [:name] }}}
            }
        )}
      }
    end
  end

  private

  def data_paginate
    {
      total_pages: @urls.total_pages,
      current_page: @urls.current_page,
      first_page: @urls.first_page?,
      last_page: @urls.last_page?,
      count: @urls.count
    }
  end

end
