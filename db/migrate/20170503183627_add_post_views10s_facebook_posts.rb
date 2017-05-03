class AddPostViews10sFacebookPosts < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :post_video_views_10s, :float, default: 0.0
  end
end
