class RemoveDataUpdatedAtFromUrls < ActiveRecord::Migration
  def change
    remove_column :urls, :data_updated_at
  end
end
