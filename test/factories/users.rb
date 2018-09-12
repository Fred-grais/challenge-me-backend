FactoryBot.define do

  factory :user do
    first_name
    last_name
    position { "CEO" }
    email
    password { "password"}
  end

end
