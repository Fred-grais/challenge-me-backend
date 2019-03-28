require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'Validations' do
    let!(:project) {FactoryBot.create(:project_no_callbacks)}
    it {should validate_uniqueness_of(:name).scoped_to(:user_id)}
  end

  describe 'Associations' do
    it {should belong_to(:user)}
    it {should have_one(:rocket_chat_details)}
  end

  describe 'Callbacks' do
    it {should callback(:create_rocket_chat_group).after(:create)}
  end

  describe 'Ancestors' do
    it 'should include the FrontDataGeneration module' do
      expect(Project.ancestors).to include(FrontDataGeneration)
    end
  end

  describe 'Constants' do
    describe 'PREVIEW_ATTRIBUTES' do
      it 'should have the correct value' do
        expect(Project::PREVIEW_ATTRIBUTES).to eq({
                                                    attributes: [:id, :name, :description],
                                                    methods: [:owner_preview, :logo_url]
                                                  })
      end
    end

    describe 'FULL_ATTRIBUTES' do
      it 'should have the correct value' do
        expect(Project::FULL_ATTRIBUTES).to eq({
                                                 attributes: [:id, :name, :description, :timeline],
                                                 methods: [:owner_full, :activity_sector_list, :challenges_needed_list, :rocket_chat_profile, :logo_url, :pictures_urls]
                                               })
      end
    end
  end

  describe '#owner_preview' do
    let(:project) {FactoryBot.create(:project_no_callbacks)}

    it 'should return the owner preview' do
      expect(project.owner_preview).to eq({
                                            :first_name => project.user.first_name,
                                            :id => project.user.id,
                                            :last_name => project.user.last_name,
                                            :position => project.user.position,
                                            :avatar_url=>nil
                                          })
    end
  end

  describe '#owner_full' do
    let(:project) {FactoryBot.create(:project_no_callbacks)}

    it 'should return the owner owner_full' do
      expect(project.owner_full).to eq({
                                         :id=>project.user.id,
                                         :email=>project.user.email,
                                         :first_name=>project.user.first_name,
                                         :last_name=>project.user.last_name,
                                         :position=>project.user.position,
                                         :status=>project.user.status,
                                         :twitter_id=>project.user.twitter_id,
                                         :timeline=>project.user.timeline,
                                         :rocket_chat_profile=>project.user.rocket_chat_profile,
                                         :avatar_url=>nil
                                       })
    end
  end

  describe '#rocket_chat_profile' do
    let(:project) {FactoryBot.create(:project_no_callbacks)}

    it 'should return the correct json' do
      expect(project.rocket_chat_profile).to eq({"name"=>project.rocket_chat_details.name})
    end
  end

  describe '#create_rocket_chat_group' do
    let!(:project) {FactoryBot.create(:project_no_callbacks)}
    let(:rocket_chat_interface_double) {double('RocketChatInterface')}

    context 'rocket_chat_details already exists' do

      it 'should not create another RocketChatDetails records' do
        expect {
          subject
        }.to change{RocketChatDetails.count}.by(0)
      end
    end

    context 'no RocketChatDetails exists' do
      let(:rocket_chat_group) { OpenStruct.new({id: 'hytyhtyh2E23', name: project.name})}
      subject { project.send(:create_rocket_chat_group) }

      before do
        project.rocket_chat_details.destroy
        project.reload
      end

      it 'should call the correct methods and create a RocketChatDetails record' do
        expect(RocketChatInterface).to receive(:new).and_return(rocket_chat_interface_double)
        expect(rocket_chat_interface_double).to receive(:create_group).with(project.name).and_return(rocket_chat_group)
        expect(rocket_chat_interface_double).to receive(:add_moderator_to_group).with(rocket_chat_group.id, project.user.rocket_chat_details.rocketchat_id)

        expect{
          subject
        }.to change{RocketChatDetails.count}.by(1)

        last_rocket_chat_details = RocketChatDetails.last

        expect(last_rocket_chat_details.rocketchat_id).to eq(rocket_chat_group.id)
        expect(last_rocket_chat_details.name).to eq(rocket_chat_group.name)
        expect(last_rocket_chat_details.rocketable_id).to eq(project.id)
        expect(last_rocket_chat_details.rocketable_type).to eq(project.class.name)
      end

      context 'errors on creation on rocketchat server' do

        before do
          expect(RocketChatInterface).to receive(:new).and_return(rocket_chat_interface_double)
          expect(rocket_chat_interface_double).to receive(:create_group).with(project.name).and_return(rocket_chat_group)
          expect(rocket_chat_interface_double).to receive(:add_moderator_to_group).with(rocket_chat_group.id, project.user.rocket_chat_details.rocketchat_id).and_raise(error_raised)
        end

        context 'Important error' do
          let(:error_raised) { RuntimeError.new('Important error') }

          it 'should re raise the error' do
            expect{
              subject
            }.to raise_error(RuntimeError).with_message('Important error').and change { RocketChatDetails.count }.by(0)
          end
        end

        context 'Unimportant error' do
          let(:error_raised) { RuntimeError.new('error-user-already-owner') }

          it 'should not re raise the error' do
            RSpec::Matchers.define_negated_matcher :not_raise_error, :raise_error
            expect{
              subject
            }.to not_raise_error.and change { RocketChatDetails.count }.by(1)
          end
        end
      end
    end
  end
end
