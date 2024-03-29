#coding: utf-8
class FbAppHyundaiParvaController < ApplicationController
  layout "fb_app_hyundai_parva"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_fanpage, :except => [:canvas]

  def index
    if session[:signed_request][:page][:liked]      
      render :index
    else
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
    else
      @nombre   = @me_from_graph[:name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end    
  end


  def bases
  end

  def redirect_share
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => @me_from_graph[:name], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :address => params[:direccion])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:actividad])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :address => params[:direccion])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:actividad])
      end
    else
      redirect_to fb_app_hyundai_parva_registro_path, :flash => { :error => "Faltan campos por llenar." }
    end
    if params[:actividad] == "laparva"
      @app.share_description = "Ya estoy participando por tickets a La Parva con Hyundai Chile."
    else
      @app.share_description = "Ya estoy participando por entradas a Kidzania con Hyundai Chile."
    end
      redirect_to eval("fb_app_hyundai_parva_share_#{params[:actividad].to_s}_path")
  end
private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '623179874380807' if Rails.env.development?
    @app_id = '665744306785813' if Rails.env.production?
    
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
  