FactoryBot.define do
  factory :message do
    message { FactoryBot.generate(:message_text) }

    trait :with_conversation_and_sender do
      before(:create)  do |message, options|
        message.conversation = FactoryBot.create(:conversation)
        message.sender = FactoryBot.create(:user)
      end
    end

    factory :message_with_sender do
      sender { FactoryBot.create(:user) }
    end
  end
end
