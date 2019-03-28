# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "Constants" do
    describe "PREVIEW_ATTRIBUTES" do
      it "should have the correct value" do
        expect(User::PREVIEW_ATTRIBUTES).to eq(
          attributes: [:id, :first_name, :last_name, :position],
          methods: [:avatar_url]
                                               )
      end
    end

    describe "FULL_ATTRIBUTES" do
      it "should have the correct value" do
        expect(User::FULL_ATTRIBUTES).to eq(
          attributes: [:id, :email, :first_name, :last_name, :position, :status, :twitter_id, :timeline],
          methods: [:rocket_chat_profile, :avatar_url]
                                            )
      end
    end

    describe "PROJECT_ATTRIBUTES_PREVIEW" do
      it "should have the correct value" do
        expect(User::PROJECT_ATTRIBUTES_PREVIEW).to eq(
          attributes: [:id, :first_name, :last_name, :position],
          method: []
                                                       )
      end
    end
  end

  describe "Associations" do
    it { should have_one(:rocket_chat_details) }
    it { should have_one(:ghost_credentials) }
    it { should have_many(:projects) }
  end

  describe "Ancestors" do
    it "should include the FrontDataGeneration module" do
      expect(User.ancestors).to include(FrontDataGeneration)
      expect(User.ancestors).to include(DeviseTokenAuth::Concerns::User)
    end
  end

  describe 'State machine "status"' do
    let(:user) { FactoryBot.create(:user) }


    it "should have the default state pending_activation" do
      expect(user).to have_state(:pending_activation)
    end

    describe "activation" do
      context "Cannot activate user" do
        it "should not allow the transition" do
          expect(user).to receive(:user_details_present?).and_return(false).exactly(:twice)
          expect(user).not_to allow_transition_to(:active)
        end
      end

      context "Can activate user" do
        let(:details_present) { true }

        it "should allow the transition" do
          expect(user).to receive(:user_details_present?).and_return(true)
          expect(user).to receive(:after_activate)
          expect(user).to transition_from(:pending_activation).to(:active).on_event(:activate)
        end
      end
    end

    describe "deactivation" do
      it "should transition from the active state to the inactive state" do
        expect(user).to transition_from(:active).to(:inactive).on_event(:deactivate)
      end
    end

    describe "reactivation" do
      it "should transition from the active state to the inactive state" do
        expect(user).to transition_from(:inactive).to(:active).on_event(:reactivate)
      end
    end

    describe "manage_status" do
      it "should transition from pending_activation to active" do
        expect(user).to receive(:user_details_present?).and_return(true)
        expect(user).to receive(:after_activate)
        expect(user).to transition_from(:pending_activation).to(:active).on_event(:manage_status)
      end

      it "should transition from active to inactive" do
        expect(user).to receive(:missing_user_details?).and_return(true)
        expect(user).to transition_from(:active).to(:inactive).on_event(:manage_status)
      end

      it "should transition from inactive to active" do
        expect(user).to receive(:user_details_present?).and_return(true)
        expect(user).to transition_from(:inactive).to(:active).on_event(:manage_status)
      end
    end
  end

  describe "#has_missing_user_details" do
    let(:user) { FactoryBot.create(:user) }
    subject { user.has_missing_user_details }

    it "should call the correct method" do
      expect(user).to receive(:missing_user_details?)
      subject
    end
  end

  describe "#full_name" do
    let(:user) { FactoryBot.create(:user) }

    context "first_name and last_name present" do
      it "should display the corect full name" do
        expect(user.full_name).to eq("#{user.first_name.capitalize} #{user.last_name.capitalize}")
      end
    end

    context "only first_name present" do
      before do
        user.last_name = nil
      end

      it "should display the corect full name" do
        expect(user.full_name).to eq("#{user.first_name.capitalize}")
      end
    end

    context "only last_name present" do
      before do
        user.first_name = nil
      end

      it "should display the corect full name" do
        expect(user.full_name).to eq("#{user.last_name.capitalize}")
      end
    end
  end

  describe "rocket_chat_profile" do
    let(:user) { FactoryBot.create(:user) }
    subject { user.rocket_chat_profile }

    it "should call the correct methods" do
      expect(user.rocket_chat_details).to receive(:as_json).with(for_front: true)
      subject
    end
  end

  describe "after_activate" do
    let(:user) { FactoryBot.create(:user) }
    subject { user.send(:after_activate) }

    it "should call the correct methods" do
      expect(user).to receive(:create_rocket_chat_user)
      expect(user).to receive(:create_ghost_user)

      subject
    end
  end

  describe "missing_user_details?" do
    let(:user) { FactoryBot.create(:user) }
    subject { user.send(:missing_user_details?) }

    it "should call the correct methods and return false" do
      expect(user).to receive(:user_details_present?).and_return(true)

      expect(subject).to be(false)
    end

    it "should call the correct methods and return true" do
      expect(user).to receive(:user_details_present?).and_return(false)

      expect(subject).to be(true)
    end
  end

  describe "user_details_present?" do
    let(:user) { FactoryBot.create(:user) }
    subject { user.send(:user_details_present?) }

    context "All necessary informations are presents" do
      it "should return true" do
        expect(subject).to be(true)
      end
    end

    context "missing first_name" do
      before do
        user.first_name = nil
      end

      it "should return false" do
        expect(subject).to be(false)
      end
    end

    context "missing last_name" do
      before do
        user.last_name = nil
      end

      it "should return false" do
        expect(subject).to be(false)
      end
    end

    context "missing position" do
      before do
        user.position = nil
      end

      it "should return false" do
        expect(subject).to be(false)
      end
    end
  end

  describe "#create_rocket_chat_user" do
    let!(:user) { FactoryBot.create(:user) }
    subject { user.send(:create_rocket_chat_user) }

    context "No current rocket_chat_details" do
      let(:rocket_chat_details_double) { double("RocketChatDetails") }
      let(:rocket_chat_user) { OpenStruct.new(id: "fezfzef223244fezf", username: "Name") }

      before do
        user.rocket_chat_details.update(rocketable_id: 0)
        user.reload
      end

      it "should create a new RocketChatDetails" do
        expect(RocketChatInterface).to receive(:new).and_return(rocket_chat_details_double)
        expect(rocket_chat_details_double).to receive(:create_user).with(user).and_return(rocket_chat_user)

        expect {
          subject
        }.to change { RocketChatDetails.count }.by(1)

        last_rocket_chat_details = RocketChatDetails.last

        expect(last_rocket_chat_details.rocketable).to eq(user)
        expect(last_rocket_chat_details.rocketchat_id).to eq(rocket_chat_user.id)
        expect(last_rocket_chat_details.name).to eq(rocket_chat_user.username)
      end
    end

    context "a rocket_chat_details already exists" do
      it "should not create a new one" do
        expect {
          subject
        }.not_to change { RocketChatDetails.count }
      end
    end
  end

  describe "#create_ghost_user" do
    let!(:user) { FactoryBot.create(:user) }
    subject { user.send(:create_ghost_user) }

    context "no current ghost_credentials" do
      before do
        user.ghost_credentials.destroy
        user.reload
      end

      it "should create a new ghost_credentials" do
        password = "password"
        expect(SecureRandom).to receive(:hex).with(32).and_return(password)

        expect {
          GhostCredentials.skip_callback(:create, :after, :create_user_in_ghost_db)
          subject
          GhostCredentials.set_callback(:create, :after, :create_user_in_ghost_db)
        }.to change { GhostCredentials.count }.by(1)

        last_ghost_credentials = GhostCredentials.last

        expect(last_ghost_credentials.user).to eq(user)
        expect(last_ghost_credentials.username).to eq(user.email)
        expect(last_ghost_credentials.password).to eq(password)
      end
    end

    context "a ghost_credentials already exists" do
      it "should not create a new ghost_credentials" do
        expect {
          user
        }.not_to change { GhostCredentials.count }
      end
    end
  end
end
