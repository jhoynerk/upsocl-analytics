class CreateCountriesMarks < ActiveRecord::Migration
  def change
    create_table :countries_marks do |t|
      t.belongs_to :country, index: true
      t.belongs_to :mark, index: true
    end
  end
end
