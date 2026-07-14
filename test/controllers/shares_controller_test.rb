require "test_helper"

class SharesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get shares_create_url
    assert_response :success
  end
end
