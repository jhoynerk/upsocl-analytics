FactoryGirl.define do
  factory :analytic_traffic, class: OpenStruct do
    pagePath url
    date Faker::Date.between(15.days.ago, Date.today).strftime('%Y%m%d')
    pageviews Faker::Number.number(2)
    visitors Faker::Number.number(2)
    traffictype Faker::Name.name
    to_create {}
  end
end
