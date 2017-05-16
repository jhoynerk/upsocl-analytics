class Url < ActiveRecord::Base
  include TagsUtil
  include Searchable

  DAY_LIMIT_TO_UPDATE = 1.day.ago.to_date

  has_enumeration_for :interval_status, with: IntervalStatus, create_scopes: { prefix: true }, create_helpers: true
  has_enumeration_for :status, with: UrlStatus, create_scopes: { prefix: true }, create_helpers: true
  belongs_to :campaign
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :tags
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

  delegate :name, to: :campaign, allow_nil: true, prefix: true

  validates :data, presence: true, url: { no_local: true, message: 'el formato no es correto' }
  validates :line_id, :profile_id, presence: true
  validates :attention, numericality: { greater_than_or_equal_to: :attention_was }, allow_blank: true
  validates :publication_date, presence: true, allow_blank: false
  validates :publication_end_date, presence: true, allow_blank: false

  before_save :set_title
  before_create :set_facebook
  after_save :set_status
  after_create :make_screenshot, :run_analytics_task
  before_destroy { |record| clean_screenshot(record.id) }

  scope :search_urls_to_update, -> { update_start_date.update_end_date }
  scope :currents, -> { where("'#{Date.today}' between publication_date  and  publication_end_date ") }
  scope :filter_by_url, -> (url_title){ where(id: ids_finding_by_title(url_title)) }
  scope :filter_name, -> (campaign_name){ joins(:campaign).where('lower("campaigns"."name") LIKE :query ', query: "%#{campaign_name.downcase}%") }
  scope :filter_client, -> (id){ joins(campaign: :users).where("users.id": id) }
  scope :filter_tag, -> (id){ joins(:tags).where(tags: { id: id }) }
  scope :filter_agency, -> (id){ joins(campaign: :agency).where(agencies: { id: id }) }

  scope :update_end_date, -> { where( 'publication_end_date >= ?', DAY_LIMIT_TO_UPDATE ) }
  scope :update_start_date, -> { where( 'publication_date <= ?', DAY_LIMIT_TO_UPDATE ) }

  scope :with_tags, -> (tags) { where(tags: {id: tags}) }

  scope :filter_date_range, -> (date) { filter_date_in_date(date) }
  scope :with_tags, -> (tags) { where(tags: {id: tags}) }

  def set_status
    self.update(status: UrlStatus::FINISHED) if reached_the_goal?
  end

  def reached_the_goal?
    status.status_active? && total_pageviews >= committed_visits
  end

  def self.ids_finding_by_title(url_title)
    where('lower("urls"."title") LIKE :query ', query: "%#{url_title.downcase}%").pluck(:id)
  end

  def self.filter_date_in_date(range)
    case range
      when DateFilter::CURRENTS
        currents
      when DateFilter::WEEKS_AGO
        where(publication_end_date: 3.week.ago..Date.today)
      else
        all
    end
  end

  def tag_titles
    tags.map(&:title).join(', ')
  end

  def goal_status
    (total_pageviews > committed_visits) ? 'Completada' : 'Sirviendo'
  end

  def fb_posts_totals
    {
      impressions: facebook_posts.sum_total_impressions,
      people_reached: facebook_posts.sum_people_reached,
      post_clicks: facebook_posts.count_post_clicks(total_pageviews),
      fb_posts_count: facebook_posts.count
    }
  end

  def update_stadistics
    AnalyticFacebook.new(self).save
  end

  def set_facebook
    self.attributes = AnalyticFacebook.new(self).update if publico == false
  end

  def set_title
    if data_changed?
      self.title = Pismo[data].titles.last.split(' | ').first
    end
  end

  def self.by_year_to_month(year ,month)
    dt = DateTime.new(year ,month)
    bom = dt.beginning_of_month
    eom = dt.end_of_month
    where("created_at >= ? and created_at <= ?", bom, eom)
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
    objects = ['dfp_stadistics','device_stadistics']
    result = {}
    objects.each do |obj|
      result[obj] = self.send(obj).where( date: datetime ).totals
    end
    result['traffic_stadistics'] = orden_traffic_stadistics(traffic_stadistics.totals)
    result['country_stadistics'] = country_stadistics.where( date: datetime ).totals(associated_countries)
    result['page_stadistics'] = country_stadistics.where( date: datetime ).totals_by_date(associated_countries)
    result
  end

  def totals_stadistics
    if countries.any?
      data = country_stadistics.where( date: datetime ).totals_filtered_by(associated_countries)
    else
      data = page_stadistics.where( date: datetime ).totals_in_range
    end
    data[:avgtimeonpage] = toClock(data[:avgtimeonpage])
    data
  end

  def toClock(secs)
    integer_secs = secs&.to_i
    DateTime.strptime(integer_secs.to_s, '%s').strftime("%M:%S")
  end

  def compute_avg(sum, count)
    count.zero? ? 0.0 : (((sum / count)) rescue 0)
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
    if nil_value_in?(@params)
      Date.today.ago(2.year)..Date.today
    else
      @params[:start_date]..@params[:end_date]
    end
  end

  def nil_value_in?(params)
    params.nil? ? true : params.values.include?(nil)
  end

  def has_facebook_post?
    facebook_posts.any?
  end

  def builder_facebook
    {
      id: id,
      title: title,
      link: data,
      visitas: totals_stadistics[:pageviews],
      shares: facebook_shares,
      comments: facebook_comments,
      likes: facebook_likes
    }
  end

  def builder_to_xls
    {
      name_campaign: campaign.name,
      ids_facebooks: facebook_posts.map(& :post_id).join(' ,')
    }
  end

  def builder_reactions
    array = Reaction.all.map do |r|
      [ "#{r.title}", votes.where("votes.reaction_id": r.id).count ]
    end
    Hash[*array.flatten]
  end

  def orden_traffic_stadistics( data )
    site = name_site
    traffic_type = { referral: 'Facebook',
      facebook: 'Facebook',
      pagina: site,
      direct: site,
      organic: 'Buscadores de Google'
    }
    data.each do |v|
      v[:traffic_type] = traffic_type[:"#{v[:traffic_type].downcase}"]
      v[:traffic_type] = 'Otros' if v[:traffic_type].nil?
    end
    sum_traffic(traffic_type, data, site)
  end

  def name_site
    (profile_id == "41995195")? "C&P" : "Upsocl"
  end
  def sum_traffic(traffic, data, site)
    facebook = 0
    upsocl = 0
    buscadores = 0
    otros = 0
    data.each do |d|
      case d[:traffic_type]
        when 'Facebook'
          facebook += 1
        when site
          upsocl += 1
        when 'Buscadores de Google'
          buscadores += 1
        when 'Otros'
          otros += 1
      end
    end

    data = group_traffic(data, 'Facebook') if (facebook > 1)
    data = group_traffic(data, site) if (upsocl > 1)
    data = group_traffic(data, 'Buscadores de Google') if (buscadores > 1)
    data = group_traffic(data, 'Otros') if (otros > 1)
    return data
  end

  def group_traffic(data, group)
    last = nil
    copy_data = []
    sum = {}
    data.each do |d|
      if d[:traffic_type] == group
        if (last.nil?)
          last = d
          sum = { traffic_type: group ,pageviews: d[:pageviews]}
        else
          sum = { traffic_type: group ,pageviews: sum[:pageviews] + d[:pageviews]}
        end
      else
        copy_data << d
      end
    end
    copy_data << sum
    return copy_data
  end

  def total_valid_with_data?
    (totals_stadistics.present? && totals_stadistics[:pageviews].present?)
  end

  def has_dfp?
    line_id != 0
  end

  def total_attention
    calculate_attention if totals_stadistics.present?
  end

  def calculate_attention
    (totals_stadistics[:avgtimeonpage].to_f * totals_stadistics[:pageviews]) / 60
  end

  def attention_last
    (total_valid_with_data?) ? total_attention : 0
  end

  def total_pageviews
    totals_stadistics[:pageviews].present? ? totals_stadistics[:pageviews] : 0
  end
end
