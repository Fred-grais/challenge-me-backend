# frozen_string_literal: true

require "rails_helper"

RSpec.describe PodcastsController, type: :controller do

  let!(:podcast) { FactoryBot.create(:podcast) }

  describe 'INDEX' do

    it 'should return the podcast' do
      get :index
      expect(response.code).to eq("200")

      expect(JSON.parse(response.body)).to eq(
        {
          "categories" => [],
          "contentUrl" => "MyString",
          "description" => "MyString",
          "duration" => "MyString",
          "originalLink" => "MyString",
          "publishingDate" => "2018-11-25T01:10:17.000Z",
          "thumbnailUrl" => "MyString",
          "title" => "MyString"
        }
      )
    end
  end
end