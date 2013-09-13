#coding: utf-8
class FbAppColemanAventureCampController < ApplicationController
  layout "fb_app_coleman_aventure_camp"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :canvas,:premios]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :canvas,:premios]
  before_filter :load_fanpage, :except => [:canvas,:premios]

  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      @menu_int = false
      render :nofans
    end
  end

  def formulario
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,@app.id])
        redirect_to fb_app_coleman_aventure_camp_share_path(:respuestas => @me_from_database_participation.answer)
      else
      @nombre    = @me_from_database.facebook_name
      @correo    = @me_from_database.facebook_email
      @telefono  = @me_from_database.phone
      @direccion = @me_from_database.address
      end
    else
      @nombre    = @me_from_graph[:name]
      @correo    = @me_from_graph[:email]
      @telefono  = ""
      @direccion = ""
    end
  end

  def trivia
    if params[:nombre].present? and params[:direccion].present? and params[:telefono].present? and params[:correo].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_gender => @me_from_graph[:gender], :facebook_email => params[:correo], :address => params[:direccion], :phone => params[:telefono])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => @me_from_graph[:name], :facebook_email => params[:correo], :address => params[:direccion], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender])
      end
    else
      redirect_to fb_app_coleman_aventure_camp_formulario_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

  def share
    @respuestas = params[:respuestas]
    if request.post?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @respuestas)
      else
        Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => @respuestas)
      end
    elsif request.get?
    end
  end

private
  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '245446828942665' if Rails.env.development?
    @app_id = '300670593407590' if Rails.env.production?
    @menu_int = true
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
  