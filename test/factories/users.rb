FactoryBot.define do

  factory :user do
    first_name
    last_name
    position { "CEO" }
    email
    password { "password"}

    before(:create){|user| user.define_singleton_method(:create_rocket_chat_user){}}
  end

end
