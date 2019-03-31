# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#as_json, preview = true, for_front = true" do
    user = FactoryBot.create(:user)

    expected = {
        "id" => user.id,
        "position" => user.position,
        "firstName" => user.first_name,
        "lastName" => user.last_name
    }
    assert_equal(expected, user.as_json(preview: true, for_front: true))
  end

  test "#as_json, preview = false, for_front = true" do
    user = FactoryBot.create(:user)

    expected = {
        "id" => user.id,
        "position" => user.position,
        "email" => user.email,
        "status" => user.status,
        "firstName" => user.first_name,
        "lastName" => user.last_name,
        "twitterId" => user.twitter_id,
        "rocketChatProfile" => { "username" => user.rocket_chat_details.username }
    }
    assert_equal(expected, user.as_json(preview: false, for_front: true))
  end

  test "user has many conversations" do
    conv = FactoryBot.create(:conversation)
    conv2 = FactoryBot.create(:conversation)

    user = FactoryBot.create(:user)

    conv.update(recipients: conv.recipients << user.email)
    conv2.update(recipients: conv2.recipients << user.email)

    assert_same_elements([conv, conv2], user.conversations)
  end

  test "#create_rocket_chat_user should call the correct method and update the user correctly" do
    user = FactoryBot.build(:user)
    User.skip_callback(:create, :after, :create_rocket_chat_user, raise: false)
    mock = OpenStruct.new(create_user: -> () { })
    RocketChatInterface.expects(:new).returns(mock)
    mock.expects(:create_user).with(user).returns(OpenStruct.new(id: 21))
    user.send(:create_rocket_chat_user)

    assert_equal("21", user.rocket_chat_user_id)
  end
end
