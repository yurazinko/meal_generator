FactoryBot.define do
  factory :meal do
    name { "Test Meal" }
    instructions { "Some instructions" }
    image_url { "http://example.com/image.jpg" }
    association :user
  end
end
