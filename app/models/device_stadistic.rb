class DeviceStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: [ :url, :device_type ] }

  validates :pageviews, :numericality => { greater_than_or_equal_to: :pageviews_was }

  scope :totals, -> { group(:device_type).sum(:pageviews).map {|c| { device: c[0].titleize, pageviews: c[1]} } }
end
