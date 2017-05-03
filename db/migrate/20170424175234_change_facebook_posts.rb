class ChangeFacebookPosts < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :title, :string
    add_column :facebook_posts, :url_video, :string
    add_column :facebook_posts, :campaign_id, :integer, index: true
    add_column :facebook_posts, :interval_status, :integer, default: 0
    add_column :facebook_posts, :total_likes, :integer, default: 0
    add_column :facebook_posts, :total_comments, :integer, default: 0
    add_column :facebook_posts, :total_shares, :integer, default: 0
  end
end
