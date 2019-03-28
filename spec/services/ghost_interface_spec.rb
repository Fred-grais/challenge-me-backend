require 'rails_helper'

RSpec.describe GhostInterface do

  describe '#initialize' do
    let(:credentials_double) { double('credentials') }

    subject { GhostInterface.new(credentials_double) }

    it 'should initiate the correct instance variable' do
      expect(subject.instance_variable_get(:@credentials)).to eq(credentials_double)
    end

  end

  describe '#create_session' do
      let(:credentials_double) { double('credentials', username: 'username', password: 'password') }

      subject {
        GhostInterface.new(credentials_double).create_session
      }

      context 'an error occurred' do

        before do
          stub_request(:post, "http://192.168.99.100:4001/ghost/api/v2/admin/session?password=password&username=username").
          with(
            headers: {
              'Origin'=>'http://blog.challenge-me.dev.com:4001'
            }).
          to_return(status: 400, body: {success: false}.to_json, headers: {})
        end
        
        it 'should raise an exception' do

          expect {
            subject
          }.to raise_error(GhostInterface::ResponseError).with_message('Error calling create_session => status 400 with body {"success":false}')
        end
      end

      context 'no error' do

        before do
          stub_request(:post, "http://192.168.99.100:4001/ghost/api/v2/admin/session?password=password&username=username").
          with(
            headers: {
              'Origin'=>'http://blog.challenge-me.dev.com:4001'
            }).
          to_return(status: 201, body: {success: false}.to_json, headers: {'set-cookie' =>  'cookie'})
        end

        it 'should return the correct response' do
          expect(subject).to eq('cookie')
        end

      end

  end
end