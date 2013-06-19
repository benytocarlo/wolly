#coding: utf-8
class FbAppHyundaiMundialController < ApplicationController
  layout "fb_app_hyundai_mundial"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_fanpage, :except => [:canvas]
  include ApplicationHelper

  def index
    if session[:signed_request][:page][:liked]      
      render :index
    else
      render :nofans
    end
  end
  
  def concurso
    regions_of_chile

    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_database.facebook_name
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
    else
      @nombre   = @me_from_graph[:name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
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

  def bases
  end

  def invitar
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present?
      @recibir_info = params[:recibir_info]
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => @me_from_graph[:name], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono],:city => params[:region], :province => params[:comuna])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :city => params[:region], :province => params[:comuna])
      end
    else
      redirect_to fb_app_hyundai_mundial_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

  def share
    @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
    if params[:uid_amigo1].present? and params[:uid_amigo2].present? and params[:uid_amigo3].present?
        @fecha = params[:uid_amigo1]+"/"+params[:uid_amigo2]+"/"+params[:uid_amigo3]+"/"+params[:recibir_info]
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:uid_amigo])
    else
      redirect_to fb_app_hyundai_mundial_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '397601957007561' if Rails.env.development?
    @app_id = '165652186949414' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
  