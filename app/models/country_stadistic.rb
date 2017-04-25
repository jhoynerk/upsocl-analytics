class CountryStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates_presence_of :url, :date, :country_code, :country_name, :pageviews, :avgtimeonpage
  validates :date, uniqueness: { scope: [ :url, :country_code ] }
  validates :avgtimeonpage, :numericality => { greater_than_or_equal_to: :avgtimeonpage_was, allow_nil: true }
  validates :pageviews, :numericality => { greater_than_or_equal_to: :pageviews_was, allow_nil: true }
  validates :users, :numericality => { greater_than_or_equal_to: :users_was, allow_nil: true }

  scope :totals, -> (countries) { (countries.any? ? where('country_code in (?)', countries) : self ).group(:country_name, :country_code).sum(:pageviews).map {|c| { name: c[0][0], code: c[0][1], pageviews: c[1], pageviews_percent: to_percent(c[1], countries) } } }
  scope :totals_by_date, -> (countries) { (countries.any? ? where('country_code in (?)', countries) : self ).select_for_date.group(:date).order(:date) }
  scope :select_for_date, -> { select('date, SUM(pageviews) as pageviews, SUM(users) as users, SUM(avgtimeonpage) as avgtimeonpage') }
  scope :totals_filtered_by, -> (countries) { where('country_code in (?)', countries).select('SUM(pageviews) as pageviews', 'SUM(users) as users', 'SUM(avgtimeonpage) as avgtimeonpage') }
  scope :totals_filtered_count, -> (countries) { where('country_code in (?)', countries).count }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true

  def self.to_percent(val, countries)
     ((val * 100).to_f / (countries.any? ? where('country_code in (?)', countries) : self ).sum(:pageviews).to_f).round(2).to_s + '%'
  end

  def self.parameters(url:, date:, country_code:, **additional_arguments)
    {
      url: url,
      date: date,
      country_code: country_code
    }
  end

  def self.attrs( country_name:, avgtimeonpage:, pageviews:, users:, **additional_arguments )
    {
      country_name: country_name,
      avgtimeonpage: avgtimeonpage,
      pageviews: pageviews,
      users: users
    }
  end
end
