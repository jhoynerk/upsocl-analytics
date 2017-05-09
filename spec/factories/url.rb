FactoryGirl.define do
  factory :url do
    campaign { create(:campaign) }
    data { "http://www.upsocl.com/comunidad/el-juez-se-levanta-totalmente-cautivado-cuando-esta-pareja-hace-esto-te-pasara-lo-mismo-2/" }
    title { Faker::Lorem.sentence }
    screenshot { Faker::Avatar.image }
    publicity { true }
    profile_id { "111669814" }
    line_id { Faker::Number.number(4) }
    interval_status { 0 }
    facebook_likes { 0 }
    facebook_comments { 0 }
    facebook_shares { 0 }
    attention { 0.0 }
    publico { false }
    publication_date { 20.day.ago }
    date_publication_completed { 6.day.ago }
  end
end
