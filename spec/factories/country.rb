FactoryGirl.define do
  factory :country do
    name { Faker::Address.country }
    code { Faker::Address.postcode}
  end
end
