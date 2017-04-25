class TrafficStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates :date, uniqueness: { scope: [ :url, :traffic_type] }
  validates :pageviews, :numericality => { greater_than_or_equal_to: :pageviews_was }

  scope :totals, -> { group(:traffic_type).sum(:pageviews).map {|c| { traffic_type: c[0].titleize, pageviews: c[1]} } }

  def self.parameters(url:, date:, traffic_type:, **additional_arguments)
    {
      url: url,
      date: date,
      traffic_type: traffic_type
    }
  end

  def self.attrs( pageviews:, **additional_arguments )
    { pageviews: pageviews }
  end
end
