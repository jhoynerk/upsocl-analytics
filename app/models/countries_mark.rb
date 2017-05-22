class CountriesMark < ActiveRecord::Base
  belongs_to :mark
  belongs_to :country
  has_many :agencies_countries_marks, join_table: :agencies_countries_marks, dependent: :destroy

  validates :country_id, uniqueness: { scope: [ :country_id, :mark_id ] }
  validates_presence_of :agencies_countries_marks, message: "El país debe tener agencia, no puede estar en blanco"
  accepts_nested_attributes_for :agencies_countries_marks, allow_destroy: :true

  delegate :name, to: :mark, allow_nil: true, prefix: true
  delegate :name, to: :country, allow_nil: true, prefix: true

  def content_search
    "#{mark_name} #{country_name}"
  end

end
