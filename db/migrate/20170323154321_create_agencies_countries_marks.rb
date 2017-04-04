class CreateAgenciesCountriesMarks < ActiveRecord::Migration
  def change
    create_table :agencies_countries_marks do |t|
      t.belongs_to :countries_mark, index: true
      t.belongs_to :agency, index: true
    end
  end
end
