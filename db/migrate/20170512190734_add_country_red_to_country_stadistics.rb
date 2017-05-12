class AddCountryRedToCountryStadistics < ActiveRecord::Migration
  def change
    add_reference :country_stadistics, :country, index: true, foreign_key: true
  end
end
