class Country < ActiveRecord::Base
  has_and_belongs_to_many :urls
  has_and_belongs_to_many :marks
  validates :name, :code, presence: true
end
