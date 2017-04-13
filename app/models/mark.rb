class Mark < ActiveRecord::Base
  validates :name, presence: true

  has_many :countries_marks, dependent: :destroy
  has_and_belongs_to_many :countries

  accepts_nested_attributes_for :countries_marks, allow_destroy: :true
end
