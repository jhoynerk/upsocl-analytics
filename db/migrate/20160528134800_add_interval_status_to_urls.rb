class AddIntervalStatusToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :interval_status, :integer, default: 0
  end
end
