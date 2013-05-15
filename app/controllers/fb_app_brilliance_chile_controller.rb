#coding: utf-8
class FbAppBrillianceChileController < ApplicationController
  layout "fb_app_brilliance_chile"
  before_filter :parse_facebook_signed_request, :except => [:new_participant]

  def parse_facebook_signed_request
    @app_id = '544692335588916' if Rails.env.development?
    @app_id = '310201642444288' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret
    @scope = 'email,read_stream,publish_stream,user_photos'
    session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    @graph = Koala::Facebook::API.new(session[:signed_request][:oauth_token])
  end  
  
  def index
    if params[:signed_request].blank?
      redirect_to "https://www.facebook.com/hmgdev/app_#{@app_id}" if Rails.env.development?
      redirect_to "https://www.facebook.com/Brilliancechile/app_#{@app_id}" if Rails.env.production?
    else
      if session[:signed_request][:page][:liked]
        render :index
      else
        render :nofans
      end
    end    
  end
  
  ##
  # Borrar este método luego que estén pasados los participantes.
  def new_participant
    Participant.create(
      :facebook_id => params[:facebook_id],
      :facebook_name => params[:facebook_name],
      :facebook_email => params[:facebook_email]
    )
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def share
  end
end
