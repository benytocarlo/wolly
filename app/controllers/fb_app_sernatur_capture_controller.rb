#coding: utf-8
class FbAppSernaturCaptureController < ApplicationController
  layout "fb_app_sernatur_capture"
  before_filter :parse_facebook_signed_request, :except => [:new_participant]

  def parse_facebook_signed_request
    @app_id = '656609567688025' if Rails.env.development?
    @app_id = '115586365316916' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret
    @scope = 'email,read_stream,publish_stream,user_photos'
    session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    @graph = Koala::Facebook::API.new(session[:signed_request][:oauth_token])
    load_facebook_user
    load_fanpage
  end   
  
  def load_fanpage
    @fanpage = @graph.get_object(session[:signed_request][:page][:id]).deep_symbolize_keys
  end
  
  def load_facebook_user
    begin
      @me_from_graph = @graph.get_object("me").deep_symbolize_keys
    rescue
      @me_from_graph = ""
    end
  end
  
  def index
    if params[:signed_request].blank? # nil? o empty?
      redirect_to "https://www.facebook.com/hmgdev/app_#{@app_id}" if Rails.env.development?
      redirect_to "https://www.facebook.com/HyundaiChile/app_#{@app_id}" if Rails.env.production?
    else
      if session[:signed_request][:page][:liked]
        render :index
      else
        render :nofans, :layout => false
      end
    end    
  end
  
  def inicio
    render :index
  end
  
  def video 
  end
  
  def especificaciones
  end

  def concurso
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_database.facebook_name
      @email    = @me_from_database.facebook_email
      @rut      = @me_from_database.rut
      @telefono = @me_from_database.phone
    else
      @nombre   = @me_from_graph[:name]
      @email    = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end
    
  end

  def share
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "Participando")
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => params[:nombre], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "Participando")
      end
    else
      redirect_to fb_app_sernatur_capture_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end
end
