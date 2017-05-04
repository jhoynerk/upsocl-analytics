class AddOriginalToFacebookPost < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :original, :boolean, default: false
  end
end
