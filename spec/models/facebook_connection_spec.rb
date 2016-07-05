require 'rails_helper'

describe FacebookConnection do
  let!(:facebook_account) { create(:facebook_account) }
  let!(:post_id) { "631142877053929" }
  let!(:fbc) { FacebookConnection.new(post_id, facebook_account.facebook_id) }

  it "facebook comments should be greater than 0" do
    expect(fbc.count_comments).to be > 0
  end

  it "facebook likes should be greater than 0" do
    expect(fbc.count_likes).to be > 0
  end

  it "facebook shares should be greater than 0" do
    expect(fbc.count_shares).to be > 0
  end

  it "should be the facebook id concatenated with the id of the post" do
    expect(fbc.user_post).to eq( "#{facebook_account.facebook_id}_#{post_id}" )
  end
end
