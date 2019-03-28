# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name
    last_name
    position { "CEO" }
    email
    password { "password" }
    twitter_id { "twitterId" }

    after(:create) do |user|
      FactoryBot.create(:rocket_chat_details, rocketable: user)
      FactoryBot.create(:ghost_credentials, user: user)
    end
  end
end
