FactoryBot.define do

  sequence(:email) { |n| "#{n}@example.com" }
  sequence(:first_name) { |n| "first_name#{n}" }
  sequence(:last_name) { |n| "last_name#{n}" }

  sequence(:name) { |n| "name#{n}" }
  sequence(:description) { |n| "description#{n}" }

  sequence(:message_text) { |n| "MyText#{n}" }

  sequence(:taggings_count) { |n| n }

  sequence(:recipient_email) do |i|
    "recipient#{i}@email.com"
  end

  sequence(:recipients) do |i|
    [FactoryBot.generate(:recipient_email), FactoryBot.generate(:recipient_email)]
  end
end
