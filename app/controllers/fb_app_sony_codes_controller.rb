#coding: utf-8
class FbAppSonyCodesController < ApplicationController
  layout "fb_app_sony_codes"
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
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND answer = 'Ganador' AND application_id = ?",@me_from_database.id,@app.id])
        redirect_to fb_app_sony_codes_count_path
      elsif @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        session[:registrado] = true
        redirect_to fb_app_sony_codes_new_code_path
      else
        @nombre   = @me_from_database.facebook_name
        @rut      = @me_from_database.rut
        @correo   = @me_from_database.facebook_email
        @telefono = @me_from_database.phone
      end
    else
      @nombre   = @me_from_graph[:name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end
  end
  
  def new_code
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @me_from_database.update_attributes(:facebook_name => @nombre_completo, :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
    else
      @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
    end
  end

  def check_respuesta
    require 'open-uri'
    require 'json'
    if params[:code].present? 
      #@result = JSON.parse(open("http://ws-wanted.herokuapp.com/facebook_id/#{@me_from_graph[:id]}/code/#{params[:codigo]}.json").read)
      #@result = @result.deep_symbolize_keys#@result = eval(@result)
      #logger.info "DEBUG: #{@result}"
      result = 0
      if result == 0
        # restar un intento al usuario, validar que no quede en negativo el numero de intento
        #redirect_to eval("fb_app_sony_codes_share_ups_path")
        if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
          if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
            answer = @me_from_database_participation.answer.to_i + 10
            @me_from_database_participation.update_attributes(:answer => answer )
          else
            Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "2")
          end
        end
        render :text => 1
      elsif result == 1
        redirect_to eval("fb_app_sony_codes_share_play_path")
      end
    else
      redirect_to fb_app_sony_codes_new_code_path, :flash => { :error => "No ha enviado ningun codigo." } 
    end
  end

private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '574833172560312' if Rails.env.development?
    @app_id = '480454252044047' if Rails.env.production?
    
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
  