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
end
