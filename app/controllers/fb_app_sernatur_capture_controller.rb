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
  
  def concurso
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
  
  def bases
  end

  def share
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present? and params[:uid_amigo].present?
      @uid   = @me_from_graph[:id]
      @uid_amigo   = params[:uid_amigo]
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => @me_from_graph[:name], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:uid_amigo])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:uid_amigo])
      end
    else
      redirect_to fb_app_sernatur_capture_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
    
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
