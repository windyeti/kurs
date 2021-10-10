require 'test_helper'

class IntegrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get integrations_new_url
    assert_response :success
  end

  test "should get create" do
    get integrations_create_url
    assert_response :success
  end

  test "should get edit" do
    get integrations_edit_url
    assert_response :success
  end

  test "should get update" do
    get integrations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get integrations_destroy_url
    assert_response :success
  end

end
