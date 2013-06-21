#coding: utf-8
class FbAppLanCargoArController < ApplicationController
  layout "fb_app_lan_cargo_ar"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request, :except => [:premios, :respuestas]
  before_filter :parse_facebook_cookies, :except => [:index, :canvas, :premios]
  before_filter :load_graph_api, :except => [:premios]
  before_filter :load_facebook_user, :except => [:index, :canvas, :premios]
  before_filter :load_fanpage, :except => [:canvas, :premios]

  def index
    if session[:signed_request][:page][:liked]      
      render :index
    else
      render :nofans
    end
  end
  
  def concurso
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_graph[:first_name]
      @apellido = @me_from_graph[:last_name]
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
    else
      begin
        @nombre   = @me_from_graph[:first_name]
        @apellido   = @me_from_graph[:last_name]
        @correo   = @me_from_graph[:email]
      rescue
        @nombre   = ""
        @apellido = ""
        @correo   = ""
      end
      @rut      = ""
      @telefono = ""
    end    
  end

  def q1
    if request.post?
      if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present?
        @nombre_completo = params[:nombre]+" "+params[:apellido]
        if params[:mail_ok] == "1"
           session[:mail_ok] = "si"
        else
           session[:mail_ok] = "no"
        end 

        if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
          @me_from_database.update_attributes(:facebook_name => @nombre_completo, :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono])
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

      session[:siguiente] = 2
      session[:answer] = params[:respuesta]
      @link = "fb_app_lan_cargo_ar_q"+session[:siguiente].to_s+"_path"

    when 2..4
      if params[:respuesta] == params[:n_preg].to_s+":c"
        @clase_exito = "exito"
        session[:puntaje] = session[:puntaje] + 1
      else
        @clase_exito = "error"
      end
      session[:siguiente] = params[:n_preg].to_i + 1

      session[:answer] = session[:answer] +"/"+ params[:respuesta]
      @link = "fb_app_lan_cargo_ar_q"+session[:siguiente].to_s+"_path"
    else
      @respuesta = "5:c"

      if params[:respuesta] == @respuesta
        @clase_exito = "exito"
        session[:puntaje] = session[:puntaje] + 1
      else
        @clase_exito = "error"
      end


      session[:answer] = session[:answer] +"/"+ params[:respuesta] +"/p:"+ session[:puntaje].to_s

      if session[:puntaje] == 5
        redirect_to fb_app_lan_cargo_ar_share_path
      else
        if session[:puntaje] > 5
          session[:puntaje] = 5
        end
        redirect_to fb_app_lan_cargo_ar_volver_jugar_path
      end
    end
  end

  def nulas
    if !session[:siguiente]
      session[:siguiente] = 2
    else
      session[:siguiente] = session[:siguiente]+1
    end
    @link = "fb_app_lan_cargo_ar_q"+session[:siguiente].to_s+"_path"
  end

  def share
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        @me_from_database_participation.update_attributes(:answer => session[:answer]+"/mail:"+session[:mail_ok])
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => session[:answer]+"/mail:"+session[:mail_ok])
      end
    end
    begin
      @graph.put_wall_post("", {
          :name => "Cargas Imposibles de Nat Geo y LAN CARGO",
          :link => "http://www.facebook.com/LANenArgentina/app_182105771955231",
          :caption => "Cargas Imposibles de Nat Geo y LAN CARGO",
          :description => "¡Ya jugué en la Trivia Cargas Imposible y estoy concursando por 2 pasajes a Lima! ¡Participá tú también AQUÍ!",
          :picture => "http://wolly.herokuapp.com/assets/fb_app_lan_cargo_ar/75x75.jpg"
      }, @me_from_graph[:id])
    rescue
      @nopost = 1
    end
  end

  def volver_jugar
    if !session[:answer]
      session[:answer] = ""
      session[:puntaje] = 0
    end

    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        @me_from_database_participation.update_attributes(:answer => session[:answer]+"/mail:"+session[:mail_ok])
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => session[:answer]+"/mail:"+session[:mail_ok])
      end
    end
    @app.share_caption = "http://www.facebook.com/LANenArgentina/app_182105771955231"
    @app.share_description = "¡Estoy jugando en la Trivia Cargas Imposible de Nat Geo y LAN CARGO para participar por 2 pasajes a Lima, Perú! ¡Concursá tú también AQUÍ!"
    begin
      @graph.put_wall_post("", {
          :name => "Cargas Imposibles de Nat Geo y LAN CARGO",
          :link => "http://www.facebook.com/LANenArgentina/app_182105771955231",
          :caption => "Cargas Imposibles de Nat Geo y LAN CARGO",
          :description => "¡Estoy jugando en la Trivia Cargas Imposible de Nat Geo y LAN CARGO para participar por 2 pasajes a Lima, Perú! ¡Concursá tú también AQUÍ!",
          :picture => "http://wolly.herokuapp.com/assets/fb_app_lan_cargo_ar/75x75.jpg"
      }, @me_from_graph[:id])
    rescue
      @nopost = 1
    end
  end

  def bases
  end

  def premios
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '641467995881277' if Rails.env.development?
    @app_id = '182105771955231' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
