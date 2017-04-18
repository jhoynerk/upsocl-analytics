class AgenciesCountriesMark < ActiveRecord::Base
  validates :agency, presence: true
  has_many :campaigns
  belongs_to :agency
  belongs_to :countries_mark
  accepts_nested_attributes_for :campaigns

  def agency_name
    agency.name
  end

  def full_info
    if countries_mark.nil?
      "#{agency_name}"
    else
      "#{countries_mark.mark_name} #{countries_mark.country_name} #{agency_name}"
    end
  end
end
