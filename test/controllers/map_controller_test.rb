require "test_helper"

class MapControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get map_index_url
    assert_response :success
  end

  test "should get search" do
    get map_search_url
    assert_response :success
  end
end
