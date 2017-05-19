class AddTrafficTypeIntToTrafficStadistics < ActiveRecord::Migration
  def change
    add_column :traffic_stadistics, :traffic_type_int, :integer, default: 0
  end
end
