class CountryStadistic < ActiveRecord::Base
  include RecordAnalytics
  include UrlsUtils

  belongs_to :url
  belongs_to :country

  validates_presence_of :url, :date, :country_code, :pageviews, :avgtimeonpage, :users
  validates :date, uniqueness: { scope: [ :url, :country_code ] }
  validates :avgtimeonpage, numericality: { greater_than_or_equal_to: :avgtimeonpage_was }, allow_blank: true
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }, allow_blank: true
  validates :users, numericality: { greater_than_or_equal_to: :users_was }, allow_blank: true

  scope :totals, -> (countries) { (countries.any? ? where('country_code in (?)', countries) : self ).group(:country_code).sum(:pageviews).map {|c| { name: c[0][0], code: c[0][1], pageviews: c[1], pageviews_percent: to_percent(c[1], countries) } } }
  scope :totals_by_date, -> (countries) { (countries.any? ? where('country_code in (?)', countries) : self ).select_for_date.group(:date).order(:date) }
  scope :select_for_date, -> { select('date, SUM(pageviews) as pageviews, SUM(users) as users, SUM(avgtimeonpage) as avgtimeonpage') }

  scope :by_date, -> (date) { where(date: date) }
  scope :by_country, -> (country) { joins(:country).where('countries.id': country) }

  scope :totals_in_range, -> { { pageviews: sum(:pageviews), users: sum(:users), avgtimeonpage: compute_avg(sum(:avgtimeonpage), count) } }
  scope :totals_filtered_by, -> (countries) { where('country_code in (?)', countries).totals_in_range }

  scope :totals_filtered_count, -> (countries) { where('country_code in (?)', countries).count }
  scope :by_assigned_country, ->  { joins(url: :countries).where("country_code = countries.code") }
  scope :countries_for_select, -> { joins(:country).distinct.select("countries.name, country_code, countries.id").order("countries.name ASC") }

  scope :select_for_country, -> { select("campaigns.name as campaign_name, urls.title as url_title, urls.id as url_id, countries.name as country_name, country_code, SUM(country_stadistics.pageviews) as pageviews, SUM(country_stadistics.avgtimeonpage) as avgtimeonpage") }
  scope :grouped_by_country, -> { group("countries.name", :country_code, "campaigns.name", "urls.title","urls.id").joins(url: [:campaign, :countries]).select_for_country.order("country_name") }
  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true

  def self.country_select_collection
    countries_for_select.pluck('countries.name', 'country_id')
  end

  def self.compute_avg( sum, count )
    count.zero? ? 0.0 : (sum / count) rescue 0
  end

  def self.to_percent(val, countries)
     ((val * 100).to_f / (countries.any? ? where('country_code in (?)', countries) : self ).sum(:pageviews).to_f).round(2).to_s + '%'
  end

  def self.parameters(**args)
    args.extract!(:url, :date, :country_code)
  end

  def search_parameters(**args)
    args.extract!(:avgtimeonpage, :pageviews, :users, :country_id)
  end

end
