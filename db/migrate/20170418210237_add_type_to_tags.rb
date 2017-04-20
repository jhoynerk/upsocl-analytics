class AddTypeToTags < ActiveRecord::Migration
  def change
    add_column :tags, :type_tag, :integer, default: 0
  end
end
