#coding: utf-8
class FbAppSernaturCaptureController < ApplicationController
  layout "fb_app_sernatur_capture"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_fanpage, :except => [:canvas]
  include ApplicationHelper

  def index
    @width = '810'
    @height = '785'

    if session[:signed_request][:page][:liked]      
      render :index
    else
      render :nofans
    end
  end
  
  def register
    @width = '810'
    @height = '800'

    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_graph[:first_name]
      @apellido   = @me_from_graph[:last_name]
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
    else
      @nombre   = @me_from_graph[:first_name]
      @apellido   = @me_from_graph[:last_name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end    
  end

  def share
    @width = '810'
    @height = '650'
    if params[:nombre].present? and params[:correo].present? and params[:rut].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @nombre_completo = params[:nombre]+" "+params[:apellido]
        @answer = params[:zipcode]+"/"+params[:url_capture]
        @me_from_database.update_attributes(:facebook_name => @nombre_completo, :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :province => params[:region], :address => params[:direccion])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @answer)
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @nombre_completo, :facebook_email => params[:correo], :facebook_gender => @me_from_graph[:gender], :province => params[:region], :address => params[:direccion])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @answer)
      end
    else
      redirect_to fb_app_sernatur_capture_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
    
  end

  def instructions
    @width = '810'
    @height = '1750'
  end

  def prize
    @width = '810'
    @height = '1000'
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '656609567688025' if Rails.env.development?
    @app_id = '115586365316916' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
