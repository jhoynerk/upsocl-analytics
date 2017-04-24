class TrafficStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: [ :url, :traffic_type] }

  validates :pageviews, :numericality => { greater_than_or_equal_to: :pageviews_was }

  scope :totals, -> { group(:traffic_type).sum(:pageviews).map {|c| { traffic_type: c[0].titleize, pageviews: c[1]} } }
end
