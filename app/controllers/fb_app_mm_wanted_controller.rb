#coding: utf-8
class FbAppMmWantedController < ApplicationController
  layout "fb_app_mm_wanted"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas]
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

  def check_respuesta
    require 'open-uri'
    require 'json'
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present? and params[:codigo].present?
      @result = JSON.parse(open("http://ws-wanted.herokuapp.com/facebook_id/#{@me_from_graph[:id]}/code/#{params[:codigo]}.json").read)
      @result = @result.deep_symbolize_keys#@result = eval(@result)
      logger.info "DEBUG: #{@result}"
      if @result[:codigo] == 0
        redirect_to eval("fb_app_mm_wanted_share_ups_path")
      elsif @result[:codigo] == 1
        ParticipantMailer.mail_mym_4entradas(params[:correo].to_s).deliver
        redirect_to eval("fb_app_mm_wanted_share_entradas_path")
      else
        ParticipantMailer.mail_mym_1millon(params[:correo].to_s).deliver
        redirect_to eval("fb_app_mm_wanted_share_millon_path")
      end

      if @result[:respuesta] == "Perdió"
        respuesta = "P"
      elsif @result[:respuesta] == "4 entradas"
        respuesta = "4E"
      elsif @result[:respuesta] == "1 millon"
        respuesta = "1M"
      end
      
      @answer = params[:codigo]+"/"+respuesta.to_s
      
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
        if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
          @me_from_database_participation.update_attributes(:answer => @me_from_database_participation.answer+"/"+@answer)
        else
          Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @answer)
        end
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
        if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
          @me_from_database_participation.update_attributes(:answer => @me_from_database_participation.answer+"/"+@answer)
        else
          Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @answer)
        end
      end
    else
      redirect_to fb_app_mm_wanted_formulario_path, :flash => { :error => "Faltan campos por llenar." } 
    end
  end

private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '697137470302264' if Rails.env.development?
    @app_id = '146259912238244' if Rails.env.production?
    
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
  