class AddFacebookToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :facebook_likes, :integer, default: 0
    add_column :urls, :facebook_comments, :integer, default: 0
    add_column :urls, :facebook_shares, :integer, default: 0
  end
end
