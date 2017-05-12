class AddDataUpdatedAtToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :data_updated_at, :datetime
  end
end
