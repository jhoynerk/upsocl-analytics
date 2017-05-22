FactoryGirl.define do
  factory :facebook_account do
    name { Faker::Name.name }
    facebook_id { "219769364857951" }
  end
end
