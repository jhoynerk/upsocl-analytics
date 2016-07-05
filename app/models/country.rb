class Country < ActiveRecord::Base
  has_and_belongs_to_many :urls
  validates :name, :code, presence: true
end
