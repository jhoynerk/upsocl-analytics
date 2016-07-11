FactoryGirl.define do
  factory :device_stadistic do
    url { create(:url) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    device_type { Faker::Lorem.words(2) }
    pageviews { Faker::Number.number(2) }
  end
end
