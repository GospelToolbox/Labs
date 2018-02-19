require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get failure" do
    get '/auth/failure'
    assert_response :success
  end

end
