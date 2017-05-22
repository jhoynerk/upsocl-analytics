class FacebookAccount < ActiveRecord::Base
  has_many :facebook_posts
  validates :name, :facebook_id, presence: true
  validates :name, :facebook_id, uniqueness: true
end
