class Country < ActiveRecord::Base
  has_and_belongs_to_many :urls
  has_and_belongs_to_many :marks
  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
  scope :in_mark, -> { joins(:marks) }
  scope :has_url, -> { includes(:urls).where.not(urls: { id: nil }) }

  scope :for_select, -> { has_url.pluck(:name, :code).to_h }
  end

end
