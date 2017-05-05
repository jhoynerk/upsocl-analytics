class FacebookPost < ActiveRecord::Base
  include TagsUtil

  belongs_to :url
  belongs_to :facebook_account
  belongs_to :campaign
  has_and_belongs_to_many :tags

  scope :urls, -> { where.not(campaign_id: nil) }
  scope :goal_achieveds, -> { urls.where(goal_achieved: true) }
  scope :unreached_goals, -> { urls.where(goal_achieved: false) }
  scope :update_interval, -> (date) { where('created_at > ? or created_at IS NULL', date) }
  scope :upgradable, -> { unreached_goals.urls.update_interval(1.month.ago) }

  scope :original_posts, -> { where(original: true) }
  scope :sum_original_impressions, -> { original_posts.sum(:post_impressions) }

  scope :ab_posts, -> { where(original: false) }
  scope :sum_ab_impressions, -> { ab_posts.sum(:post_impressions) }

  scope :sum_people_reached, -> { sum(:post_impressions_unique) }

  before_create :set_update_date
  before_validation :set_facebook
  has_enumeration_for :interval_status, with: IntervalStatus, create_scopes: { prefix: true }, create_helpers: true

  alias_attribute :facebook_likes, :total_likes
  alias_attribute :facebook_comments, :total_comments
  alias_attribute :facebook_shares, :total_shares

  validates :url_video, url: true, if: :video?
  validates :title, presence: true, if: :video?
  validates :facebook_account, :goal, presence: true
  validates_uniqueness_of :original, scope: :url_id, if: :original
  validates_numericality_of :post_id
  validates_numericality_of :goal, greater_than_or_equal_to: 1, if: :video?

  def account_id
    facebook_account.facebook_id
  end

  def has_facebook_post?
    true
  end

  def facebook_posts
    [self]
  end

  def update_stadistics
    update!(data_updated_at: Time.now)
  end

  private
  def check_goal
    self.goal_achieved = true if goal_achieved?
  end

  def goal_achieved?
    post_video_views_10s > goal
  end

  def set_update_date
    self.data_updated_at = self.created_at
  end

  def video?
    !campaign.blank?
  end

  def set_facebook
    begin
      get_stadistic_facebook
    rescue
      self.errors.add(:post_id, 'post_id no existe para esta cuenta de facebook')
      false
    end
  end

  def get_stadistic_facebook
    self.attributes = AnalyticFacebook.new(self).update_attr_post_video
    check_goal
  end

end
