# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:project) { FactoryBot.create(:project, challenges_needed_list: %w[challenge1 challenge2], activity_sector_list: %w[sector1 sector2]) }

  describe 'index' do
    it 'should get the index' do
      allow_any_instance_of(Project).to receive(:create_rocket_chat_group)
      project

      get :index

      expect(response.code).to eq('200')
      projects = Project.all.order(id: :asc)

      expected = [
        {
          'id' => projects[0].id,
          'name' => projects[0].name,
          'description' => projects[0].description,
          'logoUrl' => nil,
          'ownerPreview' => {
            'id' => projects[0].user.id,
            'avatarUrl' => nil,
            'position' => projects[0].user.position,
            'firstName' => projects[0].user.first_name,
            'lastName' => projects[0].user.last_name
          }
        },
        {
          'id' => projects[1].id,
          'name' => projects[1].name,
          'description' => projects[1].description,
          'logoUrl' => nil,
          'ownerPreview' => {
            'id' => projects[1].user.id,
            'avatarUrl' => nil,
            'position' => projects[1].user.position,
            'firstName' => projects[1].user.first_name,
            'lastName' => projects[1].user.last_name
          }
        },
        {
          'id' => projects[2].id,
          'name' => projects[2].name,
          'description' => projects[2].description,
          'logoUrl' => nil,
          'ownerPreview' => {
            'id' => projects[2].user.id,
            'avatarUrl' => nil,
            'position' => projects[2].user.position,
            'firstName' => projects[2].user.first_name,
            'lastName' => projects[2].user.last_name
          }
        }
      ]
      expect(JSON.parse(response.body)).to eq(expected)
    end
  end

  describe 'show' do
    it 'should get the project' do
      allow_any_instance_of(Project).to receive(:create_rocket_chat_group)

      get :show, params: { id: project.id }

      expect(response.code).to eq('200')

      expected = {
        'id' => project.id,
        'name' => project.name,
        'description' => project.description,
        'logoUrl' => nil,
        'activitySectorList' => %w[sector2 sector1],
        'challengesNeededList' => %w[challenge2 challenge1],
        'timeline' => {
          'items' => [
            {
              'title' => 'Title',
              'description' => 'Description',
              'date' => '10/10/2018',
              'imageUrl' => 'imageUrl'
            }
          ]
        },
        'ownerFull' => {
          'id' => project.user.id,
          'avatarUrl' => nil,
          'position' => project.user.position,
          'email' => project.user.email,
          'firstName' => project.user.first_name,
          'lastName' => project.user.last_name,
          'rocketChatProfile' => { 'name' => 'MyString' },
          'status' => 'pending_activation',
          'timeline' => { 'items' => [] },
          'twitterId' => 'twitterId'
        },
        'picturesUrls' => nil,
        'rocketChatProfile' => { 'name' => 'MyString' }
      }

      expect(JSON.parse(response.body)).to eq(expected)
    end
  end
end
