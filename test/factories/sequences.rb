FactoryBot.define do

  sequence(:email) { |n| "#{n}@example.com" }
  sequence(:first_name) { |n| "first_name#{n}" }
  sequence(:last_name) { |n| "last_name#{n}" }

  sequence(:name) { |n| "name#{n}" }
  sequence(:description) { |n| "description#{n}" }


end
