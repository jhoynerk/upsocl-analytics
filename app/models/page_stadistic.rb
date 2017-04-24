class PageStadistic < ActiveRecord::Base
  belongs_to :url
  validates :date, uniqueness: { scope: :url }

  validates_presence_of :url, :date, :pageviews, :avgtimeonpage

  scope :totals, -> { order(:date) }

  scope :totals_in_range, -> { { pageviews: sum(:pageviews), users: sum(:users), avgtimeonpage: compute_avg(sum(:avgtimeonpage), count) } }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true


  validates :avgtimeonpage, numericality: { greater_than_or_equal_to: :avgtimeonpage_was }
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }
  validates :sessions, numericality: { greater_than_or_equal_to: :sessions_was }
  validates :users, numericality: { greater_than_or_equal_to: :users_was }

  def self.compute_avg(sum, count)
    count.zero? ? 0.0 : (((sum / count)) rescue 0)
  end
end
