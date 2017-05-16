FactoryGirl.define do
  factory :dfp_data, class:Hash do
    date Faker::Date.between(2.days.ago, Date.today)
    line_name { Faker::Lorem.sentence }
    line_id Faker::Number.number(9)
    impressions Faker::Number.number(5)
    clicks Faker::Number.number(2)
    ctr Faker::Number.decimal(1)
    url { create(:url) }
    initialize_with { attributes }
  end
end

