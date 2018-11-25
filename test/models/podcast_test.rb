require 'test_helper'

class PodcastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test '#take_random' do
    Podcast.expects(:count).returns(3)
    Podcast.expects(:rand).with(3).returns(1)
    Podcast.expects(:offset).with(1).returns([])

    Podcast.take_random
  end
end
