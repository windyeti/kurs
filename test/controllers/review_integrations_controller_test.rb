require 'test_helper'

class ReviewIntegrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get review_integrations_index_url
    assert_response :success
  end

end
