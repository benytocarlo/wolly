#coding: utf-8
class FbAppMahindraReforestemosController < ApplicationController
  layout "fb_app_mahindra_reforestemos"
  before_filter :parse_facebook_signed_request

  def parse_facebook_signed_request
    @app_id = '574587429240068' if Rails.env.development?
    @app_id = '536535009742745' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret
    @scope = 'email,read_stream,publish_stream,user_photos'
    session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    @graph = Koala::Facebook::API.new(session[:signed_request][:oauth_token])
    load_facebook_user
    load_fanpage
  end
  
end