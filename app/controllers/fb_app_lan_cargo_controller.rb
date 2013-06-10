#coding: utf-8
class FbAppLanCargoController < ApplicationController
  layout "fb_app_lan_cargo"
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

  def comenzar
    if request.post?
      if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present?
        if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
          @me_from_database.update_attributes(:facebook_name => @me_from_graph[:name], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
        else
          @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
        end
      else
        redirect_to fb_app_lan_cargo_comenzar_path, :flash => { :error => "Faltan campos por llenar." }
      end
    elsif request.get?
    end
  end

  def respuestas
    if !session[:answer]
      session[:answer] = ""
      session[:puntaje] = 0
    end

    case params[:n_preg].to_i
    when 1
      if params[:respuesta] == "1:c"
        @clase_exito = "exito"
        session[:puntaje] = 1
      else
        @clase_exito = "error"
        session[:puntaje] = 0
      end

      @siguiente = 2
      session[:answer] = params[:respuesta]
      @link = "fb_app_lan_cargo_q"+@siguiente.to_s+"_path"

    when 2..6
      if params[:respuesta] == params[:n_preg].to_s+":c"
        @clase_exito = "exito"
        session[:puntaje] = session[:puntaje] + 1
      else
        @clase_exito = "error"
      end
      @siguiente = params[:n_preg].to_i + 1

      session[:answer] = session[:answer] +"/"+ params[:respuesta]
      @link = "fb_app_lan_cargo_q"+@siguiente.to_s+"_path"
    else
      @respuesta = "7:c"

      if params[:respuesta] == @respuesta
        @clase_exito = "exito"
        session[:puntaje] = session[:puntaje] + 1
      else
        @clase_exito = "error"
      end

      session[:answer] = session[:answer] +"/"+ params[:respuesta] +"/p:"+ session[:puntaje].to_s

      if session[:puntaje] == 7
        redirect_to fb_app_lan_cargo_share_path
      else
        redirect_to fb_app_lan_cargo_volver_jugar_path
      end
    end
  end

  def share
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database2 = Participation.find_by_id(@me_from_graph[:id])
        @me_from_database.update_attributes(:answer => session[:answer])
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => session[:answer])
      end
    end
  end

  def volver_jugar
    if !session[:answer]
      session[:answer] = ""
      session[:puntaje] = 0
    end

    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database2 = Participation.find_by_id(@me_from_graph[:id])
        @me_from_database.update_attributes(:answer => session[:answer])
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => session[:answer])
      end
    end
  end

  def bases
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '134653233404737' if Rails.env.development?
    @app_id = '346195818816496' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
