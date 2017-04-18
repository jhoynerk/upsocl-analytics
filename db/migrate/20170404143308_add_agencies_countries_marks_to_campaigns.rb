class AddAgenciesCountriesMarksToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :agencies_countries_mark_id, :integer
  end
end
