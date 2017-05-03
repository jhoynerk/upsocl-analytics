class CreateFacebookPostsTags < ActiveRecord::Migration
  def change
    create_table :facebook_posts_tags do |t|
      t.belongs_to :facebook_post, index: true
      t.belongs_to :tag, index: true
    end
  end
end
