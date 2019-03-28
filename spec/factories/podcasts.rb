# frozen_string_literal: true

FactoryBot.define do
  factory :podcast do
    title { "MyString" }
    description { "MyString" }
    duration { "MyString" }
    publishing_date { "2018-11-25 01:10:17" }
    thumbnail_url { "MyString" }
    content_url { "MyString" }
    original_link { "MyString" }
  end
end
