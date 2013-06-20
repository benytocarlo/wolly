#coding: utf-8
class FbAppHyundaiMundialController < ApplicationController
  layout "fb_app_hyundai_mundial"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_fanpage, :except => [:canvas]
  before_filter :header, :except => [:nofans]


  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      @header = false
      render :nofans
    end
  end
  
  def concurso
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

  def estrategia
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => @me_from_graph[:name], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :address => params[:direccion])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :address => params[:direccion])
      end
    else
      redirect_to fb_app_hyundai_mundial_concurso_path
    end
  end

  def redirect_estrategias
    flash[:tipo_estrategia] = params[:tipo_estrategia]
    redirect_to eval("fb_app_hyundai_mundial_#{params[:estrategia].to_s}_path")
  end

  def ataque 
    @clase = flash[:tipo_estrategia]
  end

  def defensa 
    @clase = flash[:tipo_estrategia]
  end

  def share
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @puntaje = 0

      case params[:estrategia_usada]
      when "defensa"
        if params[:formación] == "mod_d_451"
          @puntaje = 60
        else
          @puntaje = 30
        end

        if params[:rsp_auto1] == "Tucson"
          @puntaje = @puntaje + 10
        end

        if params[:rsp_auto2] == "Genesis"
          @puntaje = @puntaje + 10
        end

        if params[:rsp_auto3] == "Genesis Coupe"
          @puntaje = @puntaje + 10
        end

        if params[:rsp_auto4] == "Santa Fe"
          @puntaje = @puntaje + 10
        end

      when "ataque"
        if params[:formación] == "mod_a_325"
          @puntaje = 60
        else
          @puntaje = 30
        end

        if params[:rsp_auto1] == "Veloster"
          @puntaje = @puntaje + 10
        end

        if params[:rsp_auto2] == "i30"
          @puntaje = @puntaje + 10
        end

        if params[:rsp_auto3] == "Elantra"
          @puntaje = @puntaje + 10
        end

        if params[:rsp_auto4] == "Accent"
          @puntaje = @puntaje + 10
        end
      end
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        if @me_from_database_participation.answer != "100"
          @me_from_database_participation.update_attributes(:answer => @puntaje)
        end
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @puntaje)
      end

    end
  end

private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '397601957007561' if Rails.env.development?
    @app_id = '165652186949414' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end

  def header
    @header  = true
  end
end
  