FactoryBot.define do

  factory :tag, class: ActsAsTaggableOn::Tag do
    name
    taggings_count
  end

end