#coding: utf-8
class FbAppClaroMonsterController < ApplicationController
  layout "fb_app_claro_monster"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas,:galeria,:premios]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas,:galeria,:premios]
  before_filter :load_fanpage, :except => [:canvas,:galeria,:premios]

  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      @fans = false
      @nofans = true
      render :nofans
    end
  end

  def formulario
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        redirect_to fb_app_claro_monster_share_path
      else
        @nombre   = @me_from_database.facebook_name
        @correo   = @me_from_database.facebook_email
        @telefono = @me_from_database.phone
      end
    else
      @nombre   = @me_from_graph[:name]
      @apellido   = @me_from_graph[:last_name]
      @correo   = @me_from_graph[:email]
      @telefono = ""
    end
  end

  def share
    if request.post?
      require 'net/ftp'
      begin
        file = params[:file]
        if file.size > 500000 then
          redirect_to fb_app_claro_monster_formulario_path, :flash => { :notice => "El archivo es muy grande. Por favor, selecciona un archivo con un peso menor a 300Kb." }
        else  
          ftp = Net::FTP.new('190.196.67.254')
          ftp.passive = true
          ftp.login('heroku@miapp.cl', 'heroku')
          ftp.storbinary("STOR " + "claro/monster/" + @me_from_graph[:id] + "_image.jpg", StringIO.new(file.read), Net::FTP::DEFAULT_BLOCKSIZE)
          ftp.quit

          if params[:nombre].present? and params[:telefono].present? and params[:correo].present?
            if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
              @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
              Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @me_from_graph[:id] + "_image.jpg")
            else
              @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
              Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @me_from_graph[:id] + "_image.jpg")
            end
          else
            redirect_to fb_app_brother_combo_formulario_path, :flash => { :error => "Faltan campos por llenar." }
          end
        end
      rescue
        redirect_to fb_app_claro_monster_formulario_path, :flash => { :notice => "Tienes que elegir un archivo para continuar" }
      end
    elsif request.get?
    end
  end

  def galeria
    @participations = Participation.find(:all, :conditions => ["application_id = #{@app.id}"],:limit=>2,:order => "created_at ASC")
    @gallery = Array.new
    @participations.each do |participations|
      @participant = Participant.find_by_id(participations.participant_id)
      @gallery << { :image=> participations.answer , :name=> @participant.facebook_name }
    end
  end

private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '372127926247121' if Rails.env.development?
    @app_id = '1374235916136044' if Rails.env.production?
    
    if session[:app].blank? then
      @app = Application.find_by_fb_app_idnumber @app_id
      session[:app] = @app
    else
      @app = session[:app]
    end
      @fans = true
      @nofans = false
    #@app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
  