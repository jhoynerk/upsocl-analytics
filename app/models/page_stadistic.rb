class PageStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: :url }

  scope :totals, -> { order(:date) }

  scope :totals_in_range, -> { { pageviews: sum(:pageviews), users: sum(:users), avgtimeonpage: compute_avg(sum(:avgtimeonpage), count) } }

  def self.compute_avg(sum, count)
    count.zero? ? 0.0 : (sum / count rescue 0).round(2)
  end
end
