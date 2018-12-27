require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  context 'index' do
    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        get api_v1_users_path

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end
    end

    context 'Authenticated' do
      setup do
        @user = users(:one)
        @user1 = FactoryBot.create(:user, first_name: 'Zoe', last_name: 'More')
        @user2 = FactoryBot.create(:user, first_name: 'Claire', last_name: 'Lob')
        @user3 = FactoryBot.create(:user, first_name: 'Fred', last_name: 'Rev')
        @user4 = FactoryBot.create(:user, first_name: 'jean', last_name: 'Cli')
      end

      should('return the correct tags') do
        authenticate_user(@user) do |authentication_headers|
          get api_v1_users_path, headers: authentication_headers, params: {search: 'cl'}
        end

        expected = {"results"=>
                    [
                      {"firstName"=>@user2.first_name, "lastName"=>@user2.last_name, "email"=>@user2.email},
                      {"firstName"=>@user4.first_name, "lastName"=>@user4.last_name, "email"=>@user4.email}
                    ]
                    }

        assert_same_elements(expected['results'], JSON.parse(@response.body)['results'])
      end
    end
  end



end