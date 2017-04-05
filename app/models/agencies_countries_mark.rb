class AgenciesCountriesMark < ActiveRecord::Base
  has_many :campaigns
  belongs_to :agency

  accepts_nested_attributes_for :campaigns

  def agency_name
    agency.name
  end
end
