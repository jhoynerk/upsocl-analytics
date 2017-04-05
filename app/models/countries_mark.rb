class CountriesMark < ActiveRecord::Base
  belongs_to :marks
  belongs_to :country
  has_many :agencies_countries_marks, :join_table => :agencies_countries_marks

  accepts_nested_attributes_for :agencies_countries_marks, allow_destroy: :true

  def campaign_name
    country.name
  end
end
