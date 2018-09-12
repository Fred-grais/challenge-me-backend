require 'test_helper'

class MeControllerTest < ActionDispatch::IntegrationTest


  test "should get unauthorized" do
    get me_index_path
    assert_response :unauthorized
    assert_equal( "{\"errors\":[\"You need to sign in or sign up before continuing.\"]}", @response.body)
  end

  test 'should get show' do
    user = users(:one)

    authenticate_user(user) do |authentication_headers|
      get me_index_path, headers: authentication_headers

    end
    assert_response :success

    expected = {
        "data"=>
            {
                "id"=>user.id,
                "first_name"=>user.first_name,
                "last_name"=>user.last_name,
                "position"=>user.position,
                "email"=>user.email
            }
    }
    assert_equal(expected, JSON.parse(@response.body))
  end

end
