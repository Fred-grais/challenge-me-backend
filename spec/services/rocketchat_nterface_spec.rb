# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RocketChatInterface do
  describe '#initialize' do
    subject do
      RocketChatInterface.new
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      subject
    end
  end

  describe '#create_user' do
    let(:user) { FactoryBot.create(:user) }
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.create_user(user)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      expect(SecureRandom).to receive(:hex).with(16).and_return('123')

      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/users.create")
        .with(
          body: "{\"username\":\"#{rocket_chat_interface.send(:generate_name, user.full_name)}\",\"email\":\"#{user.email}\",\"name\":\"#{user.full_name}\",\"password\":\"123\",\"active\":true,\"sendWelcomeEmail\":false,\"joinDefaultChannels\":true,\"customFields\":{\"app_user_id\":#{user.id}}}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, user: { _id: 123 } }.to_json, headers: {})

      expect(subject).to have_attributes(class: RocketChat::User, id: 123)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:users).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::UserCreationError).with_message("some error for user #{user.id}")
      end
    end
  end

  describe '#get_user' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.get_user(1)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:get, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/users.info?userId=1")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, user: { _id: 123 } }.to_json, headers: {})

      expect(subject).to have_attributes(class: RocketChat::User, id: 123)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:users).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::UserInfoError).with_message('some error for user 1')
      end
    end
  end

  describe '#list_groups' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.list_groups
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:get, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/groups.list")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, groups: [{ _id: 1 }] }.to_json, headers: {})

      expect(subject).to match_array([have_attributes(class: RocketChat::Room, id: 1)])
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:groups).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when listing private rooms')
      end
    end
  end

  describe '#get_group' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.get_group(1)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:get, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/groups.info?roomId=1")
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, group: { _id: 1 } }.to_json, headers: {})

      expect(subject).to have_attributes(class: RocketChat::Room, id: 1)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:groups).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when listing group 1')
      end
    end
  end

  describe '#create_group' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.create_group('group_name')
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/groups.create")
        .with(
          body: '{"name":"group_name"}',
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, group: { _id: 1 } }.to_json, headers: {})

      expect(subject).to have_attributes(class: RocketChat::Room, id: 1)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:groups).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when creating group <group_name>')
      end
    end
  end

  describe '#delete_group' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.delete_group(1)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/groups.delete")
        .with(
          body: '{"roomId":1}',
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, group: { _id: 1 } }.to_json, headers: {})

      expect(subject).to be(true)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:groups).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when deleting group 1')
      end
    end
  end

  describe '#add_owner_to_group' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.add_owner_to_group(1, 2)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/groups.addOwner")
        .with(
          body: '{"roomId":1,"userId":2}',
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true }.to_json, headers: {})

      expect(subject).to be(true)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:groups).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when adding owner 2 to group 1')
      end
    end
  end

  describe '#add_moderator_to_group' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.add_moderator_to_group(1, 2)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/groups.addModerator")
        .with(
          body: '{"roomId":1,"userId":2}',
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true }.to_json, headers: {})

      expect(subject).to be(true)
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:groups).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when adding moderator 2 to group 1')
      end
    end
  end

  describe '#generate_auth_token_for_user' do
    let(:rocket_chat_interface) { RocketChatInterface.new }
    subject do
      rocket_chat_interface.generate_auth_token_for_user(1)
    end

    it 'should make the right calls to the server' do
      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
        .with(
          body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

      stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/users.createToken")
        .with(
          body: '{"userId":1}',
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: { success: true, data: { 'authToken' => '123', 'userId' => '1' } }.to_json, headers: {})

      expect(subject).to have_attributes(class: RocketChat::Token, auth_token: '123', user_id: '1')
    end

    context 'an error happened' do
      it 'should raise an error' do
        stub_request(:post, "#{ENV['ROCKET_CHAT_SERVER_URL']}/api/v1/login")
          .with(
            body: "{\"username\":\"#{ENV['ROCKET_CHAT_ADMIN_USERNAME']}\",\"password\":\"#{ENV['ROCKET_CHAT_ADMIN_PASSWORD']}\"}",
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Ruby'
            }
          )
          .to_return(status: 200, body: { success: true, data: [] }.to_json, headers: {})

        expect(rocket_chat_interface.instance_variable_get(:@session)).to receive(:users).and_raise(RuntimeError.new('some error'))

        expect do
          subject
        end.to raise_error(RocketChatInterface::RocketChatError).with_message('some error when generating token for user 1')
      end
    end
  end
end
