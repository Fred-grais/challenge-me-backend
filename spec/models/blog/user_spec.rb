require 'rails_helper'

RSpec.describe Blog::User, type: :model do

    describe 'Associations' do
      it {should belong_to(:ghost_credentials).with_foreign_key(:id).with_primary_key(:id).class_name('GhostCredentials')}
      it {should have_one(:role).class_name('Blog::RolesUser').inverse_of(:user).dependent(:destroy)}
      it {should have_many(:posts).class_name('Blog::Post').with_foreign_key(:author_id)}
    end

    describe 'attr_accessor' do
      let(:user) { 
        Blog::User.new(
          name: 'name',
          slug: 'slug',
          password: 'password',
          email: 'email',
          accessibility: 'accessibility',
          status: 'status',
          visibility: 'visibility',
          created_at: 'created_at',
          created_by: 'created_by'
        )
      }

      it 'should have the correct accessors' do
        expect(user.name).to eq('name')
        expect(user.slug).to eq('slug')
        expect(user.password).to eq('password')
        expect(user.email).to eq('email')
        expect(user.accessibility).to eq('accessibility')
        expect(user.status).to eq('status')
        expect(user.visibility).to eq('visibility')
        expect(user.created_at).to eq('created_at')
        expect(user.created_by).to eq('created_by')

      end

    end

    describe 'Callbacks' do
      it {should callback(:hash_password).before(:create)}
    end

    describe '#password_valid?' do
      let(:user) { Blog::User.new(password: 'password')}

      it 'should validate the password' do
          user.send(:hash_password)
          expect(user.password_valid?('password')).to be(true)
      end

      it 'should not validate the password' do
        user.send(:hash_password)
        expect(user.password_valid?('not_valid')).to be(false)
      end
    end

end
