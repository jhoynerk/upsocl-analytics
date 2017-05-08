class AddPostClicksToFacebookPost < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :post_clicks, :integer, default: 0
  end
end
