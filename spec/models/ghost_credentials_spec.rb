require 'rails_helper'

RSpec.describe GhostCredentials, type: :model do

  describe 'Validations' do
    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:password)}
  end

  describe 'Callbacks' do
    it {should callback(:create_user_in_ghost_db).after(:create)}
  end

  describe 'Associations' do
    it {should belong_to :user}
    it {should have_one(:blog_user).class_name('Blog::User').with_foreign_key('id')}
  end

  describe 'Delegations' do
    it {should delegate_method(:create_session).to(:interface)}
  end

  describe '#set_ghost_interface' do
    subject {FactoryBot.create(:ghost_credentials)}

    it 'should set the correct instance variable' do
      allow_any_instance_of(GhostCredentials).to receive(:create_user_in_ghost_db)
      expect(GhostInterface).to receive(:new).with(subject).and_call_original
      subject.send(:set_ghost_interface)
      expect(subject.interface).to be_a(GhostInterface)
    end

    it 'should be called after initialization' do
      expect_any_instance_of(GhostCredentials).to receive(:set_ghost_interface)
      GhostCredentials.new
    end
  end

  describe '#create_user_in_ghost_db' do
    let(:user) { FactoryBot.create(:user) }
    let(:id) { 456789 }
    let(:password) { 'password' }
    let(:user_double) {double(Blog::User)}
    let(:roles_user_double) {double('Blog::RolesUser')}
    let(:role_double) {double('Blog::Role')}
    let(:ghost_credentials) { FactoryBot.create(:ghost_credentials, user: user, id: id, password: password) }

    subject { ghost_credentials.send(:create_user_in_ghost_db) }

    it 'should create a Blog::User with the proper attributes' do
      #expect(Blog::Role);to receive(:find_by).with(name: 'Contributor').and_return(double)

      datetime = DateTime.now

      Timecop.freeze(datetime) do
        expect(Blog::User).to receive(:new).with(
          {
            id: id,
            name: user.full_name,
            slug: user.full_name.parameterize,
            password: password,
            email: user.email,
            accessibility: '{"nightShift":true}',
            status: :active,
            visibility: :public,
            created_at: datetime,
            created_by: 1,
            ghost_credentials: have_attributes(class: GhostCredentials, id: id)
          }
        ).and_return(user_double)

        expect(Blog::RolesUser).to receive(:new).with(id: id).and_return(roles_user_double)

        expect(Blog::Role).to receive(:find_by).with(name: 'Contributor').and_return(role_double)

        expect(user_double).to receive(:role=).with(roles_user_double)
        expect(roles_user_double).to receive(:role=).with(role_double)
        expect(user_double).to receive(:save)

        subject
      end

    end

  end
end
