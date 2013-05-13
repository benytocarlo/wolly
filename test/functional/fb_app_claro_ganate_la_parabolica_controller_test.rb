require 'test_helper'

class FbAppClaroGanateLaParabolicaControllerTest < ActionController::TestCase
  test "should get nofans" do
    get :nofans
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get share" do
    get :share
    assert_response :success
  end

end
