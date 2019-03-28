# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    recipients

    factory :conversation_with_message do
      after(:create)  do |conversation, options|
        message = FactoryBot.build(:message_with_sender)
        conversation.recipients << message.sender.email
        conversation.messages << message
      end
    end

    factory :conversation_with_messages do
      after(:create)  do |conversation, options|
        sender = FactoryBot.create(:user)
        conversation.recipients << sender.email

        3.times do
          message = FactoryBot.build(:message, sender: sender)
          conversation.messages << message
        end
      end
    end
  end
end
