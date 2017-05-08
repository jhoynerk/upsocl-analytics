class AddDefaultsToCountryStadistic < ActiveRecord::Migration
  def change
    change_column_default :country_stadistics, :avgtimeonpage, 0.0
    change_column_default :country_stadistics, :pageviews, 0
    change_column_default :country_stadistics, :users, 0
  end
end
