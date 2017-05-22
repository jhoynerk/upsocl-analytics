class AddInsightToFacebookPosts < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :post_impressions_unique, :float, default: 0.0
    add_column :facebook_posts, :post_video_avg_time_watched, :float, default: 0.0
    add_column :facebook_posts, :post_video_views, :float, default: 0.0
    add_column :facebook_posts, :post_video_view_time, :float, default: 0.0
    add_column :facebook_posts, :data_updated_at, :datetime
    add_column :facebook_posts, :goal_achieved, :boolean, default: false
    add_column :facebook_posts, :goal, :float, default: 0.0
    add_timestamps :facebook_posts
  end
end
