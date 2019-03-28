require 'rails_helper'

RSpec.describe Podcast, type: :model do

  describe 'Validations' do
    it {should validate_presence_of :title}
    it {should validate_presence_of :description}
    it {should validate_presence_of :duration}
    it {should validate_presence_of :publishing_date}
    it {should validate_presence_of :content_url}

    describe 'uniqueness' do
      let!(:podcast) { FactoryBot.create(:podcast)}

      it {should validate_uniqueness_of(:title)}
    end
  end

  describe 'Constants' do

    describe 'FULL_ATTRIBUTES' do
      it 'should have the correct value' do
        expect(Podcast::FULL_ATTRIBUTES).to eq({
                                                 attributes: [:title, :description, :categories, :duration, :publishing_date, :content_url, :thumbnail_url, :original_link],
                                               })
      end
    end
  end

  describe '#take_random' do
    let(:podcast_double) { double }
    subject { Podcast.take_random }

    it 'should call the right methods' do
      expect(Podcast).to receive(:count).and_return(2)
      expect(Podcast).to receive(:rand).with(2).and_return(4)
      expect(Podcast).to receive(:offset).with(4).and_return(podcast_double)
      expect(podcast_double).to receive(:first)

      subject
    end
  end

  describe 'Ancestors' do

    it 'should include the FrontDataGeneration module' do
      expect(Podcast.ancestors).to include(FrontDataGeneration)
    end
  end
end