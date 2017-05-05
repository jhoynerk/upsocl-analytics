class TrafficStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates_presence_of :url, :date, :traffic_type, :pageviews
  validates :date, uniqueness: { scope: [ :url, :traffic_type] }
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }, allow_blank: true

  scope :totals, -> { group(:traffic_type).sum(:pageviews).map {|c| { traffic_type: c[0].titleize, pageviews: c[1]} } }

  def self.parameters(**args)
    args.extract!(:url, :date, :traffic_type)
  end

  def search_parameters(**args)
    args.extract!(:pageviews)
  end
end
