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

  def filter_by_tag
    @videos_filtered = FacebookPost.where.not(campaign_id: nil).search(params)
    @videos = FacebookPostsDecorator.new(@videos_filtered.order(:title).page(params[:paginate_page]).per(params[:paginate_regs]))
    respond_to do |format|
      format.html {}
      format.json {
        render json:{
          paginate: data_paginate,
          records: @videos.as_json(
            methods: [ :goal_achieved?, :goal_status, :tag_titles, :agencies_countries_mark_format ],
            include: [ campaign: { include:{ users: { only: [:name] }}}]
        )}
      }
    end
  end

  private

  def data_paginate
    {
      total_pages: @videos.total_pages,
      current_page: @videos.current_page,
      first_page: @videos.first_page?,
      last_page: @videos.last_page?,
      count: @videos_filtered.count
    }
  end

  def render_to_app
    respond_to do |format|
      format.html {}
      format.json { render json: @url.as_json( methods: [ :tags, :tag_names, :campaign, :stadistics, :totals_stadistics, :next_url, :previous_url, :count_votes ]) }
    end
  end
end
