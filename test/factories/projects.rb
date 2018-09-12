FactoryBot.define do
  factory :project do
    name
    description
    user factory: :user

  end
end