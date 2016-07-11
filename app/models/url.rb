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

  accepts_nested_attributes_for :facebook_posts, allow_destroy: :true

  attr_accessor :params
  mount_uploader :screenshot, ScreenshotUploader

  validates :data, presence: true, url: { no_local: true, message: 'el formato no es correto' }
  validates :line_id, :profile_id, presence: true

  before_save :set_title
  before_create :set_update_date
  after_create :make_screenshot, :run_analytics_task
  before_update :run_bg_task
  before_destroy { |record| clean_screenshot(record.id) }

  scope :update_interval, -> (interval_start, interval_end, interval) { where( '(data_updated_at between ? and ? AND interval_status = ?) or (interval_status = ?)', interval_start, interval_end, IntervalStatus::DEFAULT ,IntervalStatus.value_for( interval ) ) }

  def social_count
    SocialShares.selected data, %w(facebook google twitter)
  end

  def total_count_facebook
    counts = { likes: 0, comments: 0, shares: 0 }
    if facebook_posts.any?
      facebook_posts.each do |fbp|
        fbc = FacebookConnection.new(fbp.post_id, fbp.account_id)
        counts[:likes] = counts[:likes] + fbc.count_likes.to_i
        counts[:comments] = counts[:comments] + fbc.count_comments.to_i
        counts[:shares] = counts[:shares] + fbc.count_shares.to_i
      end
    else
      info_social = SocialShares.selected data, %w(facebook)
      counts = { likes: info_social[:facebook]["like_count"], comments: info_social[:facebook]["comment_count"], shares: info_social[:facebook]["share_count"] }
    end
    counts
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
      result[obj] = self.send(obj).where( date: @params[:start_date]..@params[:end_date] ).totals
    end
    result['country_stadistics'] = country_stadistics.where( date: @params[:start_date]..@params[:end_date] ).totals(associated_countries)
    result['page_stadistics'] = country_stadistics.where( date: @params[:start_date]..@params[:end_date] ).totals_by_date(associated_countries)
    result
  end

  def totals_stadistics
    if countries.any?
      country_stadistics.where( date: @params[:start_date]..@params[:end_date] ).totals_filtered_by(associated_countries)[0]
    else
      page_stadistics.where( date: @params[:start_date]..@params[:end_date] ).totals_in_range
    end
  end

  def associated_countries
    countries.map(&:code)
  end

end
