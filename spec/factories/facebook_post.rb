FactoryGirl.define do
  factory :facebook_post do
    facebook_account { create(:facebook_account) }
    post_id { Faker::Number.number(15)  }
    url { create(:url) }
  end
end
