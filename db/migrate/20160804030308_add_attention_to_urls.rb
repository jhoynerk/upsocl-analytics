class AddAttentionToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :attention, :float, default: 0
  end
end
