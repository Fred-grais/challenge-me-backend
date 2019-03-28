FactoryBot.define do
  factory :ghost_credentials do
    username {"MyString"}
    password {"MyString"}
    user

    after(:build) { |ghost_credentials| GhostCredentials.skip_callback(:create, :after, :create_user_in_ghost_db) }
    after(:create) { |ghost_credentials| GhostCredentials.set_callback(:create, :after, :create_user_in_ghost_db) }
  end
end
