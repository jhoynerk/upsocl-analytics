class PageStadistic < ActiveRecord::Base
  include RecordAnalytics

  validates_presence_of :url, :date, :pageviews, :avgtimeonpage
  validates :date, uniqueness: { scope: :url }
  validates :avgtimeonpage, numericality: { greater_than_or_equal_to: :avgtimeonpage_was }
  validates :pageviews, numericality: { greater_than_or_equal_to: :pageviews_was }
  validates :sessions, numericality: { greater_than_or_equal_to: :sessions_was }
  validates :users, numericality: { greater_than_or_equal_to: :users_was }

  scope :totals, -> { order(:date) }
  scope :totals_in_range, -> { { pageviews: sum(:pageviews), users: sum(:users), avgtimeonpage: compute_avg(sum(:avgtimeonpage), count) } }

  delegate :title, :campaign_name, to: :url, allow_nil: true, prefix: true

  def self.compute_avg( sum, count )
    count.zero? ? 0.0 : (((sum / count)) rescue 0)
  end

  def self.parameters( url:, date:, **additional_arguments )
    {
      url: url,
      date: date
    }
  end

  def self.attrs( sessions:, avgtimeonpage:, pageviews:, users:, **additional_arguments )
    {
      sessions: sessions,
      avgtimeonpage: avgtimeonpage,
      pageviews: pageviews,
      users: users
    }
  end
end
