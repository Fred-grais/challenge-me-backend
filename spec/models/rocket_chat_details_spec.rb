# frozen_string_literal: true

require "rails_helper"

RSpec.describe RocketChatDetails, type: :model do
  describe "Associations" do
    it { should belong_to(:rocketable) }
  end

  describe "Ancestors" do
    it "should include the FrontDataGeneration module" do
      expect(Project.ancestors).to include(FrontDataGeneration)
    end
  end

  describe "Contants" do
    describe "PREVIEW_ATTRIBUTES" do
      it "should have the correct value" do
        expect(RocketChatDetails::PREVIEW_ATTRIBUTES).to eq(
          attributes: [:name],
          methods: []
                                                            )
      end
    end

    describe "FULL_ATTRIBUTES" do
      it "should have the correct value" do
        expect(RocketChatDetails::FULL_ATTRIBUTES).to eq(
          attributes: [:name],
          methods: []
                                                            )
      end
    end
  end
end
