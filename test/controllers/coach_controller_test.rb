require "test_helper"

class CoachControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get coach_index_url
    assert_response :success
  end
end
