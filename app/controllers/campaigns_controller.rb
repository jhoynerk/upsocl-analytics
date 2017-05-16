class CampaignsController < ApplicationController

  def index
    @campaigns = checked_campaings.decorate
    respond_to do |format|
      format.html {}
      format.json { render :json => @campaigns.as_json( methods: [ :num_urls, :ordered_by_url_created, :agencies_countries_mark_format, :facebook_posts_ordered_by_created, :tag_titles ],
                                                        include: [:urls, users: { only: [:name] }]) }
    end
  end

  def filter_by_tag
    @campaigns_filtered = Campaign.search(params)
    @campaigns = CampaignsDecorator.new(@campaigns_filtered.order(:name).page(params[:paginate_page]).per(params[:paginate_regs]))
    respond_to do |format|
      format.html {}
      format.json { render :json => {paginate: data_paginate, records: @campaigns.as_json( methods: [ :num_urls, :ordered_by_url_created, :agencies_countries_mark_format, :facebook_posts_ordered_by_created, :tag_titles ],
                                                        include: [:urls, users: { only: [:name] }]) } }
    end
  end

  def show
    @campaign = current_user.campaigns.find(params[:id]).decorate
    respond_to do |format|
      format.html {}
      format.json { render :json => @campaign.as_json(include: { urls: { methods: [ :stadistics, :totals_stadistics, :count_votes] }}) }
    end
  end

  def full_info
    @urls = checked_urls
    @urls = @urls.includes('tags').with_tags(params[:tags]) unless params[:tags].nil? or params[:tags] == ''
    respond_to do |format|
      format.html {}
      format.json { render :json => builder_data }
    end
  end

  def render_xls
    @urls = Url.by_year_to_month(params[:date][:year].to_i, params[:date][:month].to_i).where.not(campaign_id: nil)
    @urls = builder_data_to_xls
    respond_to do |format|
      format.csv { @urls.to_csv }
      format.json { render :json => builder_data }
      format.xls { }
    end
  end

  private

  def data_paginate
    {
      total_pages: @campaigns.total_pages,
      current_page: @campaigns.current_page,
      first_page: @campaigns.first_page?,
      last_page: @campaigns.last_page?,
      count: @campaigns_filtered.count
    }
  end

  def builder_data
    @urls.map do |url|
      url.builder_facebook.merge!(url.builder_reactions)
    end
  end

  def builder_data_to_xls
    @urls.map do |url|
      url.builder_facebook.merge!(url.builder_reactions).merge!(url.builder_to_xls)
      #url.merge(url.campaign.name) unless url.campaign.nil?
      #url[:ids_facebooks] = url.facebook_posts.map(& :id)
    end
  end

  def checked_urls
    if current_user.admin?
      Url.all.order(id: :asc)
    else
      return Url.where(campaign_id: current_user.campaigns.each(&:id))
    end
  end

  def checked_campaings
    if current_user.admin? || current_user.country_manager?
      Campaign.all.order(:name)
    else
      current_user.campaigns
    end
  end
end
