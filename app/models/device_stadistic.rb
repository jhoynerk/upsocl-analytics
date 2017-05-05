class DeviceStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates_presence_of :url, :date, :device_type, :pageviews
  validates :date, uniqueness: { scope: [ :url, :device_type ] }
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }, allow_blank: true

  scope :totals, -> { group(:device_type).sum(:pageviews).map {|c| { device: c[0].titleize, pageviews: c[1]} } }

  def self.parameters(**args)
    args.extract!(:url, :date, :device_type)
  end

  def search_parameters(**args)
    args.extract!(:pageviews)
  end
end
