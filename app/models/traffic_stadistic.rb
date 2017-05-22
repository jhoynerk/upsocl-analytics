class TrafficStadistic < ActiveRecord::Base
  include RecordAnalytics
  include UrlsUtils

  validates_presence_of :url, :date, :traffic_type, :pageviews
  validates :date, uniqueness: { scope: [ :url, :traffic_type] }
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }, allow_blank: true

  scope :totals, -> { pageviws_to_traffic_by.map {|c| { traffic_type: TrafficTypeStadistics.t(c[0]), pageviews: c[1]} } }
  scope :pageviws_to_traffic_by, -> { group(:traffic_type_int).sum(:pageviews) }


  before_create :select_traffic_type

  def self.parameters(**args)
    args.extract!(:url, :date, :traffic_type)
  end

  def search_parameters(**args)
    args.extract!(:pageviews)
  end

  private
    def select_traffic_type
      self.traffic_type_int = TrafficStadistics::TypesHelpers.type_by(traffic_type)
    end
end
