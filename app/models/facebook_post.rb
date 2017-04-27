class FacebookPost < ActiveRecord::Base
  include TagsUtil

  belongs_to :url
  belongs_to :facebook_account
  belongs_to :campaign
  has_many :urls, dependent: :delete_all
  has_and_belongs_to_many :tags

  before_create :set_facebook
  has_enumeration_for :interval_status, with: IntervalStatus, create_scopes: { prefix: true }, create_helpers: true

  alias_attribute :facebook_likes, :total_likes
  alias_attribute :facebook_comments, :total_comments
  alias_attribute :facebook_shares, :total_shares

  validates :url_video, url: true, unless: :video?
  validates :title, presence: true, unless: :video?
  validates :facebook_account, presence: true
  validates_numericality_of :post_id

  def account_id
    facebook_account.facebook_id
  end

  def has_facebook_post?
    true
  end

  def facebook_posts
    [self]
  end

  private

  def video?
    campaign.blank?
  end

  def set_facebook
     # if publico == false
    self.attributes = AnalyticFacebook.new(self).update
  end

end
