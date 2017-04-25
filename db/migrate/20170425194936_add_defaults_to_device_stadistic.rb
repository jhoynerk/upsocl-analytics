class AddDefaultsToDeviceStadistic < ActiveRecord::Migration
  def change
    change_column_default :device_stadistics, :pageviews, 0
  end
end
