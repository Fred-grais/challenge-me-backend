# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  context "Index" do
    should "be accessible and return the correct response" do
      get users_url
      assert_response :success

      expected = [
          {
              "id" => users(:one).id,
              "position" => users(:one).position,
              "firstName" => users(:one).first_name,
              "lastName" => users(:one).last_name
          },
          {
              "id" => users(:two).id,
              "position" => users(:two).position,
              "firstName" => users(:two).first_name,
              "lastName" => users(:two).last_name
           }
      ]
      assert_same_elements(expected, JSON.parse(@response.body))
    end
  end

  context "Show" do
    should "be accessible and return the correct response" do
      user = FactoryBot.create(:user)

      get(user_url(user))
      assert_response :success

      expected = {
          "id" => user.id,
          "position" => user.position,
          "email" => user.email,
          "firstName" => user.first_name,
          "lastName" => user.last_name
      }

      assert_equal(expected, JSON.parse(@response.body))
    end
  end
end
