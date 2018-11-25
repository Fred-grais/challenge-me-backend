require 'test_helper'

class PodcastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @podcast = FactoryBot.create(:podcast)
  end

  test "should get index" do
    get podcasts_url, as: :json
    assert_response :success

    expected = @podcast.as_json(for_front: true)
    assert_equal(expected, JSON.parse(@response.body))
  end
end
