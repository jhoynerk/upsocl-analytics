FactoryGirl.define do
  factory :analytic_country, class: OpenStruct do
    page_path url
    date "20170508"
    pageviews Faker::Number.number(2)
    visitors Faker::Number.number(2)
    sessions Faker::Number.number(2)
    avgtimeonpage Faker::Number.decimal(2)
    users Faker::Number.number(2)
    country { ['Chile', 'Argentina'].sample}
    countryIsoCode { ['CL', 'AR'].sample}
    to_create {}
  end
end
