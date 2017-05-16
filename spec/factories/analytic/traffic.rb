FactoryGirl.define do
  factory :analytic_traffic, class: OpenStruct do
    pagePath url
    date "20170508"
    pageviews Faker::Number.number(2)
    visitors Faker::Number.number(2)
    traffictype Faker::Name.name
    to_create {}
  end
end
