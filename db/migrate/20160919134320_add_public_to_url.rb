class AddPublicToUrl < ActiveRecord::Migration
  def change
     add_column :urls, :publico, :boolean, default: false
  end
end
