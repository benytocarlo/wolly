#coding: utf-8
class FbAppBrillianceEuforiaController < ApplicationController
  layout "fb_app_brilliance_euforia"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas,:ranking,:felicidades,:gracias,:invitar]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas,:ranking,:felicidades,:gracias,:invitar]
  before_filter :load_fanpage, :except => [:canvas,:ranking,:felicidades,:gracias,:invitar]

  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      @menu_int = false
      @menu_fan = true
      render :nofans
    end
  end

  def formulario
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        redirect_to fb_app_brilliance_euforia_jugar_path
      else
        @nombre   = @me_from_database.facebook_name
        @correo   = @me_from_database.facebook_email
        @rut = @me_from_database.rut
        @telefono = @me_from_database.phone
        @direccion = @me_from_database.address
      end
    else
      @nombre   = @me_from_graph[:name]
      @apellido   = @me_from_graph[:last_name]
      @correo   = @me_from_graph[:email]
      @telefono = ""
    end
    
  end

  def jugar
    if request.post?
      if params[:nombre].present? and params[:rut].present? and params[:telefono].present? and params[:correo].present?
        if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
          @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :address => params[:direccion])
        else
          @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :address => params[:direccion])
        end
      else
        redirect_to fb_app_brilliance_euforia_formulario_path, :flash => { :error => "Faltan campos por llenar." }
      end
      if !@me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = 20",@me_from_database.id])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "100")
      end
      redirect_to "http://www.appdigital.cl/brilliance/test/casino.php?fid="+@me_from_graph[:id].to_s
    elsif request.get?
      @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      redirect_to "http://www.appdigital.cl/brilliance/test/casino.php?fid="+@me_from_graph[:id].to_s
    end
  end

  def ranking 
    @participations = Participation.find(:all, :conditions => ["application_id = 20"],:limit=>10,:order => "answer DESC")
    @ranking = Array.new
    @participations.each do |participations|
      @participant = Participant.find_by_id(participations.participant_id)
      @ranking << { :answer=> participations.answer.to_i , :name=> @participant.facebook_name }
    end
  end

  def invitar
    if @me_from_database = Participant.find_by_facebook_idnumber(params[:fbid])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = 20",@me_from_database.id])
        @me_from_database_participation.update_attributes(:answer => "100")
      end
    end
  end
  
  def gracias
    @fbidvar = params[:fbid]
  end
  
private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '314578718687856' if Rails.env.development?
    @app_id = '423085667810855' if Rails.env.production?
    
    if session[:app].blank? then
      @app = Application.find_by_fb_app_idnumber @app_id
      session[:app] = @app
    else
      @app = session[:app]
    end
    @menu_int = true
    @menu_fan = false
    #@app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end