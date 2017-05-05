class AddStatusToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :status, :boolean, default: :false
  end
end
