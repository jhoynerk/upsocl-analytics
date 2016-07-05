FactoryGirl.define do
  factory :traffic_stadistic do
    url { create(:url) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    traffic_type { "referral" }
    pageviews { Faker::Number.number(4) }
  end
end
