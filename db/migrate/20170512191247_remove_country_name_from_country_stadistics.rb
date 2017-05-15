class RemoveCountryNameFromCountryStadistics < ActiveRecord::Migration
  def change
    remove_column :country_stadistics, :country_name, :string
  end
end
