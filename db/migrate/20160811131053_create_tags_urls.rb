class CreateTagsUrls < ActiveRecord::Migration
  def change
    create_table :tags_urls do |t|
      t.belongs_to :url, index: true
      t.belongs_to :tag, index: true
    end
  end
end
