FactoryGirl.define do
  factory :analytic_device, class: OpenStruct do
    page_path url
    date "20170508"
    pageviews Faker::Number.number(2)
    visitors Faker::Number.number(2)
    sessions Faker::Number.number(2)
    deviceCategory Faker::Name.name
    to_create {}
  end
end
