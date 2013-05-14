require 'test_helper'

class FbAppBrillianceChileControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get share" do
    get :share
    assert_response :success
  end

end
