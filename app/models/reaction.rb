class Reaction < ActiveRecord::Base
  mount_uploader :avatar, AvatarReactionUploader
  has_many :votes
end
