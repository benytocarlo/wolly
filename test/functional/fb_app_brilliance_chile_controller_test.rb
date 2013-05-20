require 'test_helper'

class FbAppBrillianceChileControllerTest < ActionController::TestCase
  test "should get index" do
    post :index, :post => { :signed_request => '0Ji0PGxGDCf5WBFk3qroM6zIZRyt-2pUkPuTVKhIqVI.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTM2OTA2ODg4MiwidXNlciI6eyJjb3VudHJ5IjoiY2wiLCJsb2NhbGUiOiJlbl9VUyIsImFnZSI6eyJtaW4iOjIxfX19' }
    assert_response :success
  end

  #test "should get share" do
  #  post :share
  #  assert_response :failure
  #end

end
