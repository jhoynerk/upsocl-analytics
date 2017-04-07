class CountriesMark < ActiveRecord::Base
  belongs_to :mark
  belongs_to :country
  has_many :agencies_countries_marks, :join_table => :agencies_countries_marks, dependent: :delete_all

  accepts_nested_attributes_for :agencies_countries_marks, allow_destroy: :true

  before_destroy :destroy_all_agencies_countries_marks



  def country_name
    country.name unless country.nil?
  end

  def mark_name
    mark.name unless mark.nil?
  end

  private
  def destroy_all_agencies_countries_marks
    agencies_countries_marks.delete_all if agencies_countries_marks.any?
  end
end
