class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :url, index: true
      t.belongs_to :reaction, index: true
    end
  end
end
