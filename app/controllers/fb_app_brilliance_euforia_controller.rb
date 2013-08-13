#coding: utf-8
class FbAppBrillianceEuforiaController < ApplicationController
  layout "fb_app_brilliance_euforia"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas,:ranking]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas,:ranking]
  before_filter :load_fanpage, :except => [:canvas,:ranking]

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
      @nombre   = @me_from_database.facebook_name
      @correo   = @me_from_database.facebook_email
      @rut = @me_from_database.rut
      @telefono = @me_from_database.phone
      @direccion = @me_from_database.address
    else
      @nombre   = @me_from_graph[:name]
      @apellido   = @me_from_graph[:last_name]
      @correo   = @me_from_graph[:email]
      @telefono = ""
    end
  end

  def jugar
    if params[:nombre].present? and params[:rut].present? and params[:telefono].present? and params[:correo].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :address => params[:direccion])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :address => params[:direccion])
      end
    else
      redirect_to fb_app_brilliance_euforia_formulario_path, :flash => { :error => "Faltan campos por llenar." }
    end
    redirect_to "http://www.appdigital.cl/brilliance/test/casino.php?fid=111"
  end

  def ranking 
    @participations = Participation.find(:all, :conditions => ["application_id = #{@app.id}"],:limit=>10,:order => "answer DESC")
    @ranking = Array.new
    @participations.each do |participations|
      @participant = Participant.find_by_id(participations.participant_id)
      @ranking << { :answer=> participations.answer.to_i , :name=> @participant.facebook_name }
    end
  end

  def felicidades
    if params[:fb_id].present? and params[:creditos].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(params[:fb_id])
        if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
          @me_from_database_participation.update_attributes(:answer => params[:creditos])
        else
          Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => params[:creditos])
        end
      end
    end
  end

  def gracias
    if params[:fb_id].present? and params[:creditos].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(params[:fb_id])
        if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
          @me_from_database_participation.update_attributes(:answer => "0")
        else
          Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "0")
        end
      end
   end
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