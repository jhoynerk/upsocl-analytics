class AddCommittedVisitsToUrlsTable < ActiveRecord::Migration
  def change
    add_column :urls, :committed_visits, :integer, default: 0
  end
end