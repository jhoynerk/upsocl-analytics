class AddPostImpressionsToFacebookPosts < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :post_impressions, :integer, default: 0
  end
end
