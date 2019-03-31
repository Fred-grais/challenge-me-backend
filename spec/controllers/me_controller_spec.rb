# frozen_string_literal: true

require "rails_helper"

RSpec.describe MeController, type: :controller do

  context 'unauthorized' do
    it 'should render a 401' do
      get :show
      expect(response.code).to eq("401")
      expect(response.body).to eq("{\"errors\":[\"You need to sign in or sign up before continuing.\"]}")
    end
  end

  context 'authenticated' do
    let(:user) { FactoryBot.create(:user) }

    it 'should return the correct response' do
      authenticate_user(user) do |authentication_headers|
        @request.headers.merge!(authentication_headers)
        get :show
      end

      expect(response.code).to eq('200')
      expected = {
        "data" =>
            {
              "id" => user.id,
              "firstName" => user.first_name,
              "lastName" => user.last_name,
              "position" => user.position,
              "email" => user.email,
              "avatarUrl"=>nil,
              "twitterId"=>"twitterId",
              "rocketChatProfile"=>{"name"=>"MyString"},
              "status"=>"pending_activation",
              "timeline"=>{"items"=>[]}
            }
      }

      expect(JSON.parse(response.body)).to eq(expected)

    end
  end
end