require 'test_helper'

class ConversationChannelTest < ActionCable::Channel::TestCase

  def test_subscribed_with_room_number
    # Simulate a subscription creation
    subscribe conversationId: 1

    # Asserts that the subscription was successfully created
    assert subscription.confirmed?

    # Asserts that the channel subscribes connection to a stream
    assert_equal "conversation_1", streams.last
  end
end