FactoryGirl.define do
  factory :facebook_post do
    facebook_account { create(:facebook_account) }
    post_id { "633609430140607" }
    url { create(:url) }
  end
end
