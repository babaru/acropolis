require 'test_helper'

class RiskMonitorControllerTest < ActionController::TestCase
  test "should get index" do
    @user = users(:one)
    sign_in :user, @user
    get :index
    assert_response :success
  end

end
