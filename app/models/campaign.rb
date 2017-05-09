class Campaign < ActiveRecord::Base
  include TagsUtil
  include Searchable

  belongs_to :agencies_countries_mark
  has_many :urls, dependent: :delete_all
  has_many :facebook_posts, dependent: :delete_all
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :agency
  has_one :agency, through: :agencies_countries_mark

  scope :filter_name, -> (query_string){ where('lower("campaigns"."name") LIKE :query ', query: "%#{query_string.downcase}%") }
  scope :filter_date_range, -> (date){ Campaign.filter_date_in_date(date) }
  scope :filter_client, -> (id){ joins(:users).where(id: id) }
  scope :filter_tag, -> (id){ joins(:tags).where(tags: { id: id }) }
  scope :filter_agency, -> (id){ joins(:agency).where(agencies: { id: id }) }
  scope :filter_by_url, -> (query){ where(id: Campaign.search_by_url_ids(query)) }
  scope :unreached_goals, -> { where(id: Campaign.unreached_goals_ids) }

  accepts_nested_attributes_for :urls, allow_destroy: :true
  accepts_nested_attributes_for :facebook_posts, allow_destroy: :true

  scope :with_tags, -> (tags) { where(tags: {id: tags}) }
  validates :name, presence: true

  def self.search_by_url_ids(query_string)
    campaign_by_facebook = FacebookPost.where('lower("facebook_posts"."url_video") LIKE :query ', query: "%#{query_string.downcase}%").pluck(:campaign_id)
    campaign_by_url = Url.where('lower("urls"."data") LIKE :query ', query: "%#{query_string.downcase}%").pluck(:campaign_id)
    campaign_by_facebook + campaign_by_url
  end

  def self.unreached_goals_ids
    campaign_by_facebook = FacebookPost.unreached_goals.pluck(:campaign_id)
    campaign_by_url = Url.search_urls_to_update.pluck(:campaign_id)
    campaign_by_facebook + campaign_by_url
    campaign_by_facebook
  end

  def self.filter_date_in_date(range)
    case range
    when 1
      unreached_goals
    when 2
      where(created_at: 3.week.ago .. Date.today)
    else
      all
    end
  end

  def tag_titles
    tags.map(&:title).join(', ')
  end

  def ordered_by_url_created
    urls.order('urls.created_at DESC')
  end

  def facebook_posts_ordered_by_created
    facebook_posts
  end

  def join_users
    users.map(&:name).join(', ')
  end

  def num_urls
    urls.count
  end

end
