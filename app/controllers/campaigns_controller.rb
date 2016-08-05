class CampaignsController < ApplicationController

  def index
    @campaigns = checked_campaings.decorate
    respond_to do |format|
      format.html {}
      format.json { render :json => @campaigns.as_json(methods: :num_urls, include: [:urls, users: { only: [:name] } ] ) }
    end
  end

  def show
    @campaign = current_user.campaigns.find(params[:id]).decorate
    respond_to do |format|
      format.html {}
      format.json { render :json => @campaign.as_json(include: { urls: { methods: [ :social_count, :stadistics, :totals_stadistics, :count_votes] }}) }
    end
  end

  def full_info
    @urls = Url.all.order(id: :asc)
    respond_to do |format|
      format.html {}
      format.json { render :json => builder_data }
    end
  end

  private

  def builder_data
    @urls.map do |url|
      url.builder_facebook.merge!(url.builder_reactions)
    end
    #@urls.as_json(methods: [ :totals_stadistics, :count_votes ] )
  end

  def checked_campaings
    if current_user.admin?
      Campaign.all.order(:name)
    else
      current_user.campaigns
    end

  end

end
