require "test_helper"

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get preferences_update_url
    assert_response :success
  end
end
