class DfpStadistic < ActiveRecord::Base
  include RecordAnalytics
  include UrlsUtils

  validates :date, uniqueness: { scope: [ :url, :line_id ] }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true
  scope :by_date, -> (date) { where(date: date) }
  scope :totals, -> { { impressions: sum(:impressions), clicks: sum(:clicks), ctr: ((sum(:clicks).to_f / sum(:impressions).to_f) * 100) } }


  def self.parameters(**args)
    args.extract!(:url, :date, :line_id)
  end

  def search_parameters(**args)
    args.extract!(:impressions, :clicks, :ctr)
  end
end
