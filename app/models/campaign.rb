class Campaign < ActiveRecord::Base
  include TagsUtil
  belongs_to :agencies_countries_mark
  has_many :urls, dependent: :delete_all
  has_many :facebook_posts, dependent: :delete_all
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :urls, allow_destroy: :true
  accepts_nested_attributes_for :facebook_posts, allow_destroy: :true

  scope :with_tags, -> (tags) { where(tags: {id: tags}) }
  validates :name, presence: true

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
