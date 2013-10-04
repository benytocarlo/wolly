#coding: utf-8
class FbAppHyundaiAlientoController < ApplicationController
  layout "fb_app_hyundai_aliento"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  #before_filter :parse_facebook_cookies, :except => [:index, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas]
  before_filter :load_fanpage, :except => [:canvas]

  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      @menu = false
      render :nofans
    end
  end

  def formulario
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        redirect_to fb_app_hyundai_aliento_share_path
      else
      @nombre   = @me_from_database.facebook_name
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
      @direccion = @me_from_database.address
      @occupation = @me_from_database.occupation
      end
    else
      @nombre    = @me_from_graph[:name]
      @correo    = @me_from_graph[:email]
      @telefono  = ""
      @direccion = ""
    end
  end

  def escoge
    if params[:nombre].present? and params[:rut].present? and params[:direccion].present? and params[:telefono].present? and params[:correo].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :address => params[:direccion], :phone => params[:telefono])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :address => params[:direccion], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
      end
    else
      redirect_to fb_app_hyundai_aliento_escoge_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

  def share
    if request.post?
      @respuesta = params[:opcion_selected]
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @respuesta)
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @respuesta)
      end
    elsif request.get?
    end
  end

private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '1422314701321806' if Rails.env.development?
    @app_id = '396708980455034' if Rails.env.production?
    
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
  