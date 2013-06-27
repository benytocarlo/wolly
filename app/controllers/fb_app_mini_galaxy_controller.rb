#coding: utf-8
class FbAppMiniGalaxyController < ApplicationController
  layout "fb_app_mini_galaxy"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas]
  before_filter :load_fanpage, :except => [:canvas]
  include ApplicationHelper

  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      @header = false
      render :nofans
    end
  end
  
  def formulario
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_database.facebook_name
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
      @direccion = @me_from_database.address
      @occupation = @me_from_database.occupation
    else
      @nombre   = @me_from_graph[:name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end
    regions_of_chile
  end

  def share
    if params[:marca].present? and params[:modelo].present? and params[:year].present?
      @answer = params[:marca]+"/"+params[:modelo]+"/"+params[:year]+"/participando"
    else
      @answer = "participando"
    end
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @me_from_database.update_attributes(:facebook_name => @me_from_graph[:name], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono],:occupation => params[:ocupacion],:city => params[:region],:province => params[:comuna])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        @me_from_database_participation.update_attributes(:answer => @answer)
      else 
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @answer)
      end
    else
      @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender],:occupation => params[:ocupacion],:city => params[:region],:province => params[:comuna])
      Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @answer)
    end
  end

  def comunas
    @region = params[:type]
    @communes = communes_of @region
    @communes_of_region = "<option selected='selected' disabled='disabled' value=''>Elige tu comuna...</option>"
    @communes.each do |commune|
      @communes_of_region = "#{@communes_of_region} <option value='#{commune}'>#{commune}</option>"
    end
    render :text => @communes_of_region
  end

private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '399650510156235' if Rails.env.development?
    @app_id = '185731364926226' if Rails.env.production?
    
    if session[:app].blank? then
      @app = Application.find_by_fb_app_idnumber @app_id
      session[:app] = @app
    else
      @app = session[:app]
    end
    
    #@app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
