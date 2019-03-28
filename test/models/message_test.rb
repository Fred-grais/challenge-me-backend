# frozen_string_literal: true

require "test_helper"

class MessageTest < ActiveSupport::TestCase
  context "validations" do
    should validate_presence_of(:conversation_id)
    should validate_presence_of(:sender_id)
    should validate_presence_of(:message)
  end

  test "validate that sender is part of the conversation" do
    conversation = FactoryBot.create(:conversation)
    user = FactoryBot.create(:user)

    conversation.recipients = ["random@email.com"]
    message = Message.new(conversation: conversation, sender: user, message: "test")

    assert_equal(false, message.valid?)
    assert_equal(["Not recipient #{user.email} is not a recipient of the conversation #{conversation.id}"], message.errors.full_messages)
  end

  context "Associations" do
    should belong_to(:conversation)
    should belong_to(:sender)
  end
end
