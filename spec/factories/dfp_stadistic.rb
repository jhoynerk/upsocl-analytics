FactoryGirl.define do
  factory :dfp_stadistic do
    url { create(:url) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    line_name { Faker::Lorem.sentence }
    line_id { Faker::Number.number(4) }
    impressions { Faker::Number.number(3) }
    clicks { Faker::Number.number(4) }
    ctr { Faker::Number.decimal(2) }
  end
end
