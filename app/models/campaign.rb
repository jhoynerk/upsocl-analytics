class Campaign < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :urls, dependent: :delete_all

  accepts_nested_attributes_for :urls, allow_destroy: :true

  validates :name, presence: true

  def ordered_by_url_created
  	urls.order('urls.created_at DESC')
  end

  def join_users
    users.map(&:name).join(', ')
  end

  def num_urls
    urls.count
  end

end
