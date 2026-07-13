require "test_helper"

class SpotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get spots_index_url
    assert_response :success
  end

  test "should get show" do
    get spots_show_url
    assert_response :success
  end

  test "should get new" do
    get spots_new_url
    assert_response :success
  end

  test "should get create" do
    get spots_create_url
    assert_response :success
  end

  test "should get edit" do
    get spots_edit_url
    assert_response :success
  end

  test "should get update" do
    get spots_update_url
    assert_response :success
  end

  test "should get destroy" do
    get spots_destroy_url
    assert_response :success
  end
end
