class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.string :title, null: false
      t.integer :order, null: false
      t.string :avatar, null: false
    end
  end
end
