class PageStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: :url }

  validates_presence_of :url, :date, :pageviews, :avgtimeonpage

  scope :totals, -> { order(:date) }

  scope :totals_in_range, -> { { pageviews: sum(:pageviews), users: sum(:users), avgtimeonpage: compute_avg(sum(:avgtimeonpage), count) } }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true

  def self.compute_avg(sum, count)
    count.zero? ? 0.0 : (((sum / count)) rescue 0)
  end
end
