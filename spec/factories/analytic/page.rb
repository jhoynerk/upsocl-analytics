FactoryGirl.define do
  factory :analytic_page, class: OpenStruct do
    pagePath url
    date "20170508"
    pageviews Faker::Number.number(2)
    visitors Faker::Number.number(2)
    sessions Faker::Number.number(2)
    avgtimeonpage Faker::Number.decimal(2)
    users Faker::Number.number(2)
    to_create {}
  end
end
