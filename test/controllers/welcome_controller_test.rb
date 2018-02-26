require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_url
    assert_redirected_to '/auth/sso'
  end

end
