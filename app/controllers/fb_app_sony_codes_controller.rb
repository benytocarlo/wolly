#coding: utf-8
class FbAppSonyCodesController < ApplicationController
  layout "fb_app_sony_codes"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas]
  before_filter :load_fanpage, :except => [:canvas]
  include ApplicationHelper
  
  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      render :nofans
    end
  end
  
  def formulario
    require 'open-uri'
    require 'json'
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["answer = 'Ganador' AND application_id = ?",@app.id])
        redirect_to fb_app_sony_codes_count_path
      elsif @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        session[:registrado] = true
        redirect_to fb_app_sony_codes_new_code_path
      else
        @nombre   = @me_from_database.facebook_name
        @rut      = @me_from_database.rut
        @correo   = @me_from_database.facebook_email
        @telefono = @me_from_database.phone
        @result = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/crear_participante/facebook_id/#{@me_from_graph[:id]}.json").read)
        @result = @result.deep_symbolize_keys#@result = eval(@result)
        logger.info "DEBUG: Ingresa Usuario al WS #{@result}"
        #begin
          #@graph.put_wall_post("", {
              #:name => "Sony Codes",
              #:link => "http://www.facebook.com/SonyChile/app_480454252044047",
              #:caption => "¡Participa tú también AQUÍ!",
              #:description => "Estoy descifrando el Sony Code del Día para ganar un PlayStation 3 al instante",
              #:picture => "http://wolly.herokuapp.com/assets/fb_app_sony_codes/75x75.jpg"
          #}, @me_from_graph[:id])
        #rescue
          #@nopost = 1
        #end
      end
    else
      @nombre   = @me_from_graph[:name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
      @result = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/crear_participante/facebook_id/#{@me_from_graph[:id]}.json").read)
      @result = @result.deep_symbolize_keys#@result = eval(@result)
      logger.info "DEBUG: Ingresa Usuario al WS #{@result}"
      #begin
        #@graph.put_wall_post("", {
            #:name => "Sony Codes",
            #:link => "http://www.facebook.com/SonyChile/app_480454252044047",
            #:caption => "¡Participa tú también AQUÍ!",
            #:description => "Estoy descifrando el Sony Code del Día para ganar un PlayStation 3 al instante",
            #:picture => "http://wolly.herokuapp.com/assets/fb_app_sony_codes/75x75.jpg"
        #}, @me_from_graph[:id])
      #rescue
        #@nopost = 1
      #end
    end
    regions_of_chile
    
  end
  
  def new_code
    require 'open-uri'
    require 'json'
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @me_from_database.update_attributes(:facebook_name => @nombre_completo, :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
    else
      @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
    end
    
    @result = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/intento/facebook_id/#{@me_from_graph[:id]}.json").read)
    @result = @result.deep_symbolize_keys#@result = eval(@result)
    logger.info "DEBUG: Devuelve Intentos #{@result}"
    
    #@premios = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/premios/premios.json").read)
    #@premios = @premios.deep_symbolize_keys#@result = eval(@result)
    #logger.info "DEBUG: Devuelve Premios ya entregadas #{@result}"
  end

  def check_respuesta
    require 'open-uri'
    require 'json'
    if params[:code].present? 
      
      #@resultado = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/codigo/facebook_id/#{@me_from_graph[:id]}/code/#{params[:code]}.json").read)
      #@resultado = @resultado.deep_symbolize_keys#@result = eval(@result)
      #logger.info "DEBUG: Devuelve Intentos #{@result}"
      #if @resultado[:resultado] == "Gano"
        #render :text => 2
      #elsif @resultado[:intentos].to_i <= 0 || @resultado[:intentos].to_i > 3
        #render :text => "sinintentos"
      #elsif @resultado[:intentos].to_i > 0 && @resultado[:intentos].to_i <= 3
        #render :text => "tieneintentos"
      #end
      render :text => "tieneintentos"
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
  