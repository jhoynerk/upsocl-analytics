class Tag < ActiveRecord::Base
  has_and_belongs_to_many :urls
  has_and_belongs_to_many :campaigns

  has_enumeration_for :type_tag, with: TagType, create_helpers: true, create_scopes: { prefix: true }

end
