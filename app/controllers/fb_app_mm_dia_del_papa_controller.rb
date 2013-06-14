#coding: utf-8
class FbAppMmDiaDelPapaController < ApplicationController
  layout "fb_app_mm_dia_del_papa"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas]
  before_filter :load_fanpage, :except => [:canvas]

  def index
    
    if session[:signed_request][:page][:liked]
      @height = '785'
      render :index
    else
      @height = '615'
      render :nofans
    end
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '170246789812135' if Rails.env.development?
    @app_id = '426961747401021' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream'
  end
end
  