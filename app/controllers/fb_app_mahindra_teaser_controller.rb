#coding: utf-8
class FbAppMahindraTeaserController < ApplicationController
  layout "fb_app_mahindra_teaser"
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
  
  def concurso
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


  def bases
  end

  def share
    @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
    if params[:uid_amigo1].present? and params[:uid_amigo2].present? and params[:uid_amigo3].present?
        @fecha = params[:uid_amigo1]+"/"+params[:uid_amigo2]+"/"+params[:uid_amigo3]+"/"+params[:recibir_info]
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:uid_amigo])
    else
      redirect_to fb_app_mahindra_xuv_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '612928952058879' if Rails.env.development?
    @app_id = '322583301208964' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream'
  end
end
  