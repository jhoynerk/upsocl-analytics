class RemoveCommittedVisitsFromUrls < ActiveRecord::Migration
  def change
    remove_column :urls, :committed_visits
  end
end
