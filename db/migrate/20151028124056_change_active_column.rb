class ChangeActiveColumn < ActiveRecord::Migration
  def change
    rename_column :users, :active, :admin
  end
end
