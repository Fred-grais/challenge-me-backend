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
    user factory: :user

  end
end