FactoryBot.define do
  factory :project do
    name
    description
    timeline do
      {
        items: [
          {
            title: 'Title',
            description: 'Description',
            date: '10/10/2018',
            imageUrl: 'imageUrl'
          }
        ]
      }
    end
    user

    after(:create) {|project| FactoryBot.create(:rocket_chat_details, rocketable: project)}

    factory :project_no_callbacks do
      after(:build) { |project| Project.skip_callback(:create, :after, :create_rocket_chat_group) }
      after(:create) { |project| Project.set_callback(:create, :after, :create_rocket_chat_group) }
    end

  end
end