class Url < ActiveRecord::Base
  has_enumeration_for :interval_status, with: IntervalStatus, create_scopes: { prefix: true }, create_helpers: true
  belongs_to :campaign
  has_and_belongs_to_many :countries
  has_many :page_stadistics
  has_many :dfp_stadistics
  has_many :country_stadistics
  has_many :device_stadistics
  has_many :traffic_stadistics
  has_many :facebook_posts
  has_many :votes
  accepts_nested_attributes_for :facebook_posts, allow_destroy: :true

  attr_accessor :params
  mount_uploader :screenshot, ScreenshotUploader

  validates :data, presence: true, url: { no_local: true, message: 'el formato no es correto' }
  validates :line_id, :profile_id, presence: true

  before_save :set_title
  before_create :set_facebook
  before_create :set_update_date
  after_create :make_screenshot, :run_analytics_task
  before_update :run_bg_task
  before_destroy { |record| clean_screenshot(record.id) }

  scope :update_interval, -> (interval_start, interval_end, interval) { where( '(data_updated_at between ? and ? AND interval_status = ?) or (interval_status = ?)', interval_start, interval_end, IntervalStatus::DEFAULT ,IntervalStatus.value_for( interval ) ) }

  def social_count
    SocialShares.selected data, %w(facebook google twitter)
  end

  def set_facebook
    self.attributes = AnalyticFacebook.new(self).update
  end

  def set_title
    if data_changed?
      self.title = Pismo[data].titles.last.split(' | ').first
    end
  end

  def set_update_date
    self.data_updated_at = self.created_at
  end

  def run_bg_task
    if self.data_changed?
      make_screenshot
      run_analytics_task
    end
  end

  def run_analytics_task
    Rake::Task["analytics:add_records"].invoke('week', 'day', id)
  end
  handle_asynchronously :run_analytics_task

  def make_screenshot
    if screenshot.nil?
      url =  Cloudinary::Utils.cloudinary_url(data, :type => "url2png", :crop => "fill", :width => 1080, :height => 320, :gravity => :north, :sign_url => true)
      path = Rails.root.join('public', 'screenshot', "screenshot.png")
      open(path, 'wb') do |file|
        file << open(url).read
      end
      screenshot = path
      File.delete(path)
    end
  end
  handle_asynchronously :make_screenshot

  def clean_screenshot(id)
    path = Rails.root.join('public', 'screenshot', "#{id}.png")
    File.delete( path ) if File.exist?( path )
  end

  def only_path
    URI.parse(data).path
  end

  def stadistics
    objects = ['dfp_stadistics','device_stadistics','traffic_stadistics']
    result = {}
    objects.each do |obj|
      result[obj] = self.send(obj).where( date: datetime ).totals
    end
    result['country_stadistics'] = country_stadistics.where( date: datetime ).totals(associated_countries)
    result['page_stadistics'] = country_stadistics.where( date: datetime ).totals_by_date(associated_countries)
    result
  end

  def totals_stadistics
    if countries.any?
      country_stadistics.where( date: datetime ).totals_filtered_by(associated_countries)[0]
    else
      page_stadistics.where( date: datetime ).totals_in_range
    end
  end

  def associated_countries
    countries.map(&:code)
  end

  def count_votes
    Reaction.all.map do |r| 
      {title: r.title, reaction_id: r.id, counts: votes.where("votes.reaction_id": r.id).count} 
    end
  end

  def remove_vote(reaction_id)
    if votes.any?
      all_votes = votes.where(reaction_id: reaction_id)
      all_votes.last.delete unless all_votes.nil?
    end
  end

  def next_url
    campaign_urls.where('urls.id > ?', id).first
  end

  def previous_url
    campaign_urls.where('urls.id < ?', id).last
  end

  def campaign_urls
    campaign.urls
  end

  def datetime
    unless @params.nil?
      @params[:start_date]..@params[:end_date]
    else
      Date.today.ago(2.year)..Date.today
    end
  end

  def has_facebook_post?
    facebook_posts.any?
  end

  def builder_facebook
    {
      id: id,
      title: title,
      visitas: totals_stadistics[:pageviews],
      shares: facebook_shares,
      comments: facebook_comments,
      likes: facebook_likes
    }
  end

  def builder_reactions 
    array = Reaction.all.map do |r|
      [ "#{r.title}", votes.where("votes.reaction_id": r.id).count ]
    end
    Hash[*array.flatten]
  end
end
