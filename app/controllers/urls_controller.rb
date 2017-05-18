class UrlsController < ApplicationController
  layout false, except: :index

  def index
    @urls_filtered = Url.all
    @urls = UrlsDecorator.new(@urls_filtered.order(:title).page(1).per(10))
    respond_to do |format|
      format.html {}
      format.json {
        render json:{
          paginate: data_paginate,
          records: @urls.as_json(
            methods: [ :goal_status, :tag_titles, :agencies_countries_mark_format ],
            include: [ :countries, campaign: { include:{ users: { only: [:name] }}}]
        )}
      }
    end
  end


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
          paginate: data_paginate,
          records: @urls.as_json(
            methods: [ :goal_status, :tag_titles, :agencies_countries_mark_format ],
            include: [ :countries, campaign: { include:{ users: { only: [:name] }}}]
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
      count: @urls_filtered.count
    }
  end

end
