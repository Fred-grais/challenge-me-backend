require 'test_helper'

class Api::V1::TagsControllerTest < ActionDispatch::IntegrationTest

  context 'index' do
    context 'Not Authenticated' do

      should 'render an unauthorized error' do
        get api_v1_tags_path

        assert_response :unauthorized
        assert_equal({"errors"=>["You need to sign in or sign up before continuing."]}, JSON.parse(@response.body))
      end
    end

    context 'Authenticated' do
      setup do
        @user = users(:one)
        @tag1 = FactoryBot.create(:tag, name: 'Marketing')
        @tag2 = FactoryBot.create(:tag, name: 'Communication')
        @tag3 = FactoryBot.create(:tag, name: 'Sales')
        @tag4 = FactoryBot.create(:tag, name: 'Informatics')
      end

      should('return the correct tags') do
        authenticate_user(@user) do |authentication_headers|
          get api_v1_tags_path, headers: authentication_headers, params: {search: 'at'}
        end

        expected = {'result' => [{'text' => @tag2.name}, {'text' => @tag4.name}]}

        assert_equal(expected, JSON.parse(@response.body))
      end
    end
  end



end