class AgenciesCountriesMark < ActiveRecord::Base
  has_many :campaigns
  belongs_to :agency

  accepts_nested_attributes_for :campaigns
end
