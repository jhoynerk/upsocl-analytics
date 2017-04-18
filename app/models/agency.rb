class Agency < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  has_and_belongs_to_many :countries_marks

  before_destroy :agency_with_marks?

  private
    def agency_with_marks?
        errors.add(:base, "No se puede eliminar la Agencia con Clientes") unless countries_marks.count == 0
        errors.blank? #return false, to not destroy the element, otherwise, it will delete.
    end
end
