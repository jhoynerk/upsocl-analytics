class DeviceStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates :date, uniqueness: { scope: [ :url, :device_type ] }
  validates :pageviews, :numericality => { greater_than_or_equal_to: :pageviews_was }

  scope :totals, -> { group(:device_type).sum(:pageviews).map {|c| { device: c[0].titleize, pageviews: c[1]} } }

  def self.parameters(url:, date:, device_type:, **additional_arguments)
    {
      url: url,
      date: date,
      device_type: device_type
    }
  end

  def self.attrs( pageviews:, **additional_arguments )
    { pageviews: pageviews }
  end
end
