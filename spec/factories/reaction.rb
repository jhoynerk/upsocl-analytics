FactoryGirl.define do
  factory :reaction do
    title { Faker::Name.title }
    order { Faker::Number.number(1) }
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public', 'uploads', 'reaction' ,'avatar', '1', 'enamora.png'), 'image/png') }
  end
end
