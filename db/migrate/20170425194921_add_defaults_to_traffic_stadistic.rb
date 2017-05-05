class AddDefaultsToTrafficStadistic < ActiveRecord::Migration
  def change
    change_column_default :traffic_stadistics, :pageviews, 0
  end
end
