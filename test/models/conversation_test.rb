require 'test_helper'

class ConversationTest < ActiveSupport::TestCase

  test 'Cannot have multiple conversations with same recipients' do
    conv = FactoryBot.create(:conversation)
    assert_raises(ActiveRecord::RecordInvalid) { Conversation.create!(recipients: conv.recipients) }
    assert_raises(ActiveRecord::RecordInvalid) { Conversation.create!(recipients: conv.recipients.reverse) }
  end

  test 'expanded_recipients' do
    user = FactoryBot.create(:user)
    user1 = FactoryBot.create(:user)
    conv = FactoryBot.create(:conversation, recipients: [user.email, user1.email])

    expanded_recipients = [
      {
        'id' => user.id,
        'first_name' => user.first_name,
        'last_name' => user.last_name,
        'position' => user.position
      },
      {
        'id' => user1.id,
        'first_name' => user1.first_name,
        'last_name' => user1.last_name,
        'position' => user1.position
      }
    ]

    assert_same_elements(expanded_recipients, conv.expanded_recipients)

  end
end
