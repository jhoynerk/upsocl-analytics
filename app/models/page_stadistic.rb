class PageStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates_presence_of :url, :date, :pageviews, :avgtimeonpage, :sessions, :users
  validates :date, uniqueness: { scope: :url }
  validates :avgtimeonpage, numericality: { greater_than_or_equal_to: :avgtimeonpage_was }, allow_blank: true
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }, allow_blank: true
  validates :sessions, numericality: { greater_than_or_equal_to: :sessions_was }, allow_blank: true
  validates :users, numericality: { greater_than_or_equal_to: :users_was }, allow_blank: true

  scope :totals, -> { order(:date) }
  scope :totals_in_range, -> { { pageviews: sum(:pageviews), users: sum(:users), avgtimeonpage: compute_avg(sum(:avgtimeonpage), count) } }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true

  def self.compute_avg( sum, count )
    count.zero? ? 0.0 : (sum / count) rescue 0
  end

  def self.parameters(**args)
    args.extract!(:url, :date)
  end

  def search_parameters(**args)
    args.extract!(:sessions, :avgtimeonpage, :pageviews, :users)
  end
end
