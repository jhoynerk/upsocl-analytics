class DfpStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: [ :url, :line_id ] }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true

  scope :totals, -> { { impressions: sum(:impressions), clicks: sum(:clicks), ctr: ((sum(:clicks).to_f / sum(:impressions).to_f) * 100) } }

end
