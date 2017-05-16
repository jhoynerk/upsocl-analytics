class AddStatusToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :status, :integer, default: 0
  end
end
