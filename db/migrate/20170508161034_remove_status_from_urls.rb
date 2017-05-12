class RemoveStatusFromUrls < ActiveRecord::Migration
  def change
    remove_column :urls, :status
  end
end
