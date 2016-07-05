FactoryGirl.define do
  factory :country_stadistic do
    url { create(:url) }
    date { Faker::Date.between(2.days.ago, Date.today) }
    country_name { Faker::Address.country }
    country_code { Faker::Address.postcode}
    pageviews { Faker::Number.number(2) }
    users { Faker::Number.number(2) }
    avgtimeonpage { Faker::Number.decimal(2) }
  end
end
