#coding: utf-8
class FbAppSonyCodesController < ApplicationController
  layout "fb_app_sony_codes"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas, :count]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas, :count]
  before_filter :load_fanpage, :except => [:canvas, :count]
  include ApplicationHelper
  
  def index
    if session[:signed_request][:page][:liked]
      require 'open-uri'
      require 'json'
      @jugada = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/participacion.json").read)
      @jugada = @jugada.deep_symbolize_keys#@result = eval(@result)
      if @jugada[:respuesta] == "jugar"
        render :index
      else
        redirect_to fb_app_sony_codes_count_path
      end  
    else
      render :nofans
    end
  end
  
  def formulario
    require 'open-uri'
    require 'json'
    @jugada = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/participacion.json").read)
    @jugada = @jugada.deep_symbolize_keys#@result = eval(@result)
    if @jugada[:respuesta] == "jugar"
      #if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database = Participant.find(:first,:conditions=>["facebook_idnumber=? AND facebook_name !=''",@me_from_graph[:id]])
        if @me_from_database_participation = Participation.find(:first,:conditions =>["answer = 'Ganador' AND application_id = ?",@app.id])
          redirect_to fb_app_sony_codes_count_path
        elsif @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
          session[:registrado] = true
          redirect_to fb_app_sony_codes_new_code_path
        else
          @nombre   = @me_from_database.facebook_name
          @correo   = @me_from_database.facebook_email
          @telefono = @me_from_database.phone
          @result = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/crear_participante/facebook_id/#{@me_from_graph[:id]}.json").read)
          @result = @result.deep_symbolize_keys#@result = eval(@result)
          logger.info "DEBUG: Ingresa Usuario al WS #{@result}"
          begin
            @graph.put_wall_post("", {
                :name => "¡Participa en Sony Code!",
                :link => "http://www.facebook.com/SonyChile/app_480454252044047",
                :caption => "¡Participa tú también AQUÍ!",
                :description => "Estoy descifrando el Sony Code del Día para ganar un PlayStation 3 al instante",
                :picture => "http://wolly.herokuapp.com/assets/fb_app_sony_codes/75x75.jpg"
            }, @me_from_graph[:id])
          rescue
            @nopost = 1
          end
        end
      else
        @nombre   = @me_from_graph[:name]
        @correo   = @me_from_graph[:email]
        @result = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/crear_participante/facebook_id/#{@me_from_graph[:id]}.json").read)
        @result = @result.deep_symbolize_keys#@result = eval(@result)
        logger.info "DEBUG: Ingresa Usuario al WS #{@result}"
        begin
          @graph.put_wall_post("", {
              :name => "¡Participa en Sony Code!",
              :link => "http://www.facebook.com/SonyChile/app_480454252044047",
              :caption => "¡Participa tú también AQUÍ!",
              :description => "Estoy descifrando el Sony Code del Día para ganar un PlayStation 3 al instante",
              :picture => "http://wolly.herokuapp.com/assets/fb_app_sony_codes/75x75.jpg"
          }, @me_from_graph[:id])
        rescue
          @nopost = 1
        end
      end
      regions_of_chile
    else
      redirect_to fb_app_sony_codes_count_path
    end  
  end
  
  def new_code
    require 'open-uri'
    require 'json'
    
    if request.post?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :phone => params[:codigotel]+"-"+params[:telefono], :province => params[:region])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "Participando")
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :phone => params[:codigotel]+"-"+params[:telefono], :facebook_gender => @me_from_graph[:gender], :province => params[:region])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "Participando")
      end
    elsif request.get?
    end
    
    @intentos = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/intentos/#{@me_from_graph[:id]}.json").read)
    @intentos = @intentos.deep_symbolize_keys#@result = eval(@result)
    logger.info "DEBUG: Devuelve Intentos #{@intentos}"

    @premios = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/premios.json").read)
    @premios = @premios.deep_symbolize_keys#@result = eval(@result)
    logger.info "DEBUG: Devuelve Premios #{@premios}"
    
    @friend = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/friends/facebook_id/#{@me_from_graph[:id]}.json").read)
    @friend = @friend.deep_symbolize_keys#@result = eval(@result)
    logger.info "DEBUG: Devuelve Amigos #{@friend}"
  end

  def check_respuesta
    require 'open-uri'
    require 'json'
    if params[:code].present? 
      @resultado = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/create_winner/facebook_id/#{@me_from_graph[:id]}/code/#{params[:code]}.json").read)
      @resultado = @resultado.deep_symbolize_keys#@result = eval(@result)
      logger.info "DEBUG: Devuelve Intentos #{@result}"
      if @resultado[:respuesta] == "Winner"
        render :text => "win"
      elsif (@resultado[:respuesta] == "Loser") && (@resultado[:intentos].to_i <= 0 || @resultado[:intentos].to_i > 3)
        render :text => "nointentos"
      elsif @resultado[:respuesta] == "Loser" && @resultado[:intentos].to_i > 0 && @resultado[:intentos].to_i <= 3
        render :text => @resultado[:intentos].to_i
      elsif @resultado[:respuesta] == "No_Prizes_Left"
        render :text => "nopremio"
      end
    end
    if params[:friend].present? && params[:count].present?
      @resultado = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/actualizar_participante/facebook_id/#{@me_from_graph[:id]}/amigos_share/#{params[:friend]}/count/#{params[:count]}.json").read)
      @resultado = @resultado.deep_symbolize_keys#@result = eval(@result)
      if @resultado[:respuesta] == "update_participation"
        @intentos = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/intentos/#{@me_from_graph[:id]}.json").read)
        @intentos = @intentos.deep_symbolize_keys#@result = eval(@result)
        logger.info "DEBUG: Devuelve Intentos #{@intentos}"
        render :text => @intentos[:numero_de_intentos].to_i
      elsif @resultado[:respuesta] == "no update_participation"
        render :text => "fracaso"
      end
    end
  end
  
  def count
    require 'open-uri'
    require 'json'
    @premios = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/premios.json").read)
    @premios = @premios.deep_symbolize_keys#@result = eval(@result)
    logger.info "DEBUG: Devuelve Premios #{@result}"
  end

  def share_play
    require 'open-uri'
    require 'json'
    @ganador = JSON.parse(open("http://ws-wanted.herokuapp.com/sony/premios.json").read)
    @ganador = @ganador.deep_symbolize_keys#@result = eval(@result)
    if @ganador[:respuesta] == "ganador"
      begin
        @graph.put_wall_post("", {
            :name => "¡Soy el ganador de un PlayStation 3!",
            :link => "http://www.facebook.com/SonyChile/app_480454252044047",
            :caption => "¡Participa tú también AQUÍ!",
            :description => "Descifre el Sony código del día y desactive los láser. Esto es vivir en estado Play.",
            :picture => "http://wolly.herokuapp.com/assets/fb_app_sony_codes/75x75.jpg"
        }, @me_from_graph[:id])
      rescue
        @nopost = 1
      end
    else
      redirect_to fb_app_sony_codes_new_code_path
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