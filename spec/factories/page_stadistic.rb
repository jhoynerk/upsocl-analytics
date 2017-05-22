FactoryGirl.define do
  factory :page_stadistic do
    url { create(:url) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    pageviews { Faker::Number.number(3) }
    sessions { Faker::Number.number(4) }
    avgtimeonpage { Faker::Number.decimal(2) }
    users { Faker::Number.number(4) }
  end
end
