class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :path_url
      t.timestamps null: false
    end
  end
end
