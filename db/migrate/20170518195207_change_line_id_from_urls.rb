class ChangeLineIdFromUrls < ActiveRecord::Migration
  def change
    change_column :urls, :line_id, :integer, limit: 8, default: 0
  end
end
