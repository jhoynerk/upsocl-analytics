class CountryStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: [ :url, :country_code ] }

  validates_presence_of :url, :date, :country_code, :country_name, :pageviews, :avgtimeonpage

  scope :totals, -> (countries) { (countries.any? ? where('country_code in (?)', countries) : self ).group(:country_name, :country_code).sum(:pageviews).map {|c| { name: c[0][0], code: c[0][1], pageviews: c[1], pageviews_percent: to_percent(c[1], countries) } } }

  scope :totals_by_date, -> (countries) { (countries.any? ? where('country_code in (?)', countries) : self ).select_for_date.group(:date).order(:date) }
  scope :select_for_date, -> { select('date, SUM(pageviews) as pageviews, SUM(users) as users, SUM(avgtimeonpage) as avgtimeonpage') }

  scope :totals_filtered_by, -> (countries) { where('country_code in (?)', countries).select('SUM(pageviews) as pageviews', 'SUM(users) as users', 'SUM(avgtimeonpage) as avgtimeonpage') }
  scope :totals_filtered_count, -> (countries) { where('country_code in (?)', countries).count }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true
  def self.to_percent(val, countries)
     ((val * 100).to_f / (countries.any? ? where('country_code in (?)', countries) : self ).sum(:pageviews).to_f).round(2).to_s + '%'
  end

end
