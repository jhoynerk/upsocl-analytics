class AgenciesCountriesMark < ActiveRecord::Base
  has_many :campaigns
  has_many :agencies

  accepts_nested_attributes_for :agencies, allow_destroy: :true
  accepts_nested_attributes_for :campaigns, allow_destroy: :true
end
