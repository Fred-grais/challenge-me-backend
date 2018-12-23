require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test '#as_json, preview = true, for_front = true' do
    user = FactoryBot.create(:user)

    expected = {
        "id"=>user.id,
        "position"=>user.position,
        "firstName"=>user.first_name,
        "lastName"=>user.last_name
    }
    assert_equal(expected, user.as_json(preview: true, for_front: true))
  end

  test '#as_json, preview = false, for_front = true' do
    user = FactoryBot.create(:user)

    expected = {
        "id"=>user.id,
        "position"=>user.position,
        "email"=>user.email,
        "firstName"=>user.first_name,
        "lastName"=>user.last_name
    }
    assert_equal(expected, user.as_json(preview: false, for_front: true))
  end

  test 'user has many conversations' do
    conv = FactoryBot.create(:conversation)
    conv2 = FactoryBot.create(:conversation)
    conv3 = FactoryBot.create(:conversation)

    user = FactoryBot.create(:user)

    conv.update(recipients: conv.recipients << user.email)
    conv2.update(recipients: conv2.recipients << user.email)

    assert_same_elements([conv, conv2], user.conversations)
  end
end
