#coding: utf-8
class FbAppExampleController < ApplicationController
  layout "fb_app_example"
  before_filter :parse_facebook_signed_request

  def parse_facebook_signed_request
    @app_id = '433252186786179' if Rails.env.development?

    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret
    @scope = 'email,read_stream,publish_stream,user_photos'
    session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    @graph = Koala::Facebook::API.new(session[:signed_request][:oauth_token])
  end

  def index
    @me = @graph.get_object("me")
  end

  def canvas
  end

  def share
  end
end
