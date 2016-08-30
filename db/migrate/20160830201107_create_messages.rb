class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :message, null: false
      t.integer :status, null: false, default: 0
      t.integer :type_update, null: false, default: 0
      t.timestamps null: false
    end
  end
end
