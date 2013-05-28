#coding: utf-8
class FbAppClaroGanateLaParabolicaController < ApplicationController
  layout "fb_app_claro_ganate_la_parabolica"
  before_filter :parse_facebook_signed_request
  before_filter :load_facebook_user, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_fanpage, :except => [:index, :canvas]
  helper :fb_app_claro_ganate_la_parabolica
  
  def parse_facebook_signed_request
    @app_id = '576458172388003' if Rails.env.development?
    @app_id = '249879041820433' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret
    @scope = 'email,read_stream,publish_stream,user_photos'
    session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    @graph = Koala::Facebook::API.new(session[:signed_request][:oauth_token])
  end

  def index
    if session[:signed_request][:page][:liked]
      render :index
    else
      render :nofans
    end
  end
  
  def registro
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_database.facebook_name
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
      @region   = @me_from_database.province
    else
      @nombre   = @me_from_graph[:name]
      @correo    = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end    
  end

  def procesar_registro
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present? and params[:region].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :province => params[:region])
        # Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "Participando")
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => params[:nombre], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :province => params[:region])
        # Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "Participando")
      end
      redirect_to fb_app_claro_ganate_la_parabolica_pregunta_path
    else
      redirect_to fb_app_claro_ganate_la_parabolica_registro_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

  def canvas
    @page_url = "https://www.facebook.com/hmgdev/app_#{@app_id}" if Rails.env.development?
    @page_url = "https://www.facebook.com/clarochile/app_#{@app_id}" if Rails.env.production?
    render :redirect
    #render :js => "window.location.top = 'https://www.facebook.com/clarochile/app_#{@app_id}'" if Rails.env.production?
    #redirect_to "https://www.facebook.com/hmgdev/app_#{@app_id}" if Rails.env.development?
    #redirect_to "https://www.facebook.com/clarochile/app_#{@app_id}" if Rails.env.production?
  end

  def premios
  end
  
  def ranking
    @participations = Participation.find(:all, :conditions => ["application_id = #{@app.id}"])
    
    @regions = Array.new
    @regions << { :number => 'I'   , :name => 'Tarapacá',           :points => @participations.count{ |participation| participation.answer == '1' } }
    @regions << { :number => 'II'  , :name => 'Antofagasta',        :points => @participations.count{ |participation| participation.answer == '2' } }
    @regions << { :number => 'III' , :name => 'Atacama',            :points => @participations.count{ |participation| participation.answer == '3' } }
    @regions << { :number => 'IV'  , :name => 'Coquimbo',           :points => @participations.count{ |participation| participation.answer == '4' } }
    @regions << { :number => 'V'   , :name => 'Valparaíso',         :points => @participations.count{ |participation| participation.answer == '5' } }
    @regions << { :number => 'VI'  , :name => "O'Higgins",          :points => @participations.count{ |participation| participation.answer == '6' } }
    @regions << { :number => 'VII' , :name => 'Maule',              :points => @participations.count{ |participation| participation.answer == '7' } }
    @regions << { :number => 'VIII', :name => 'Biobío',             :points => @participations.count{ |participation| participation.answer == '8' } }
    @regions << { :number => 'IX'  , :name => 'La Araucanía',       :points => @participations.count{ |participation| participation.answer == '9' } }
    @regions << { :number => 'X'   , :name => 'Los Lagos',          :points => @participations.count{ |participation| participation.answer == '10' } }
    @regions << { :number => 'XI'  , :name => 'Aysén',              :points => @participations.count{ |participation| participation.answer == '11' } }
    @regions << { :number => 'XII' , :name => 'Magallanes',         :points => @participations.count{ |participation| participation.answer == '12' } }
    @regions << { :number => 'XIII', :name => 'Metropolitana',      :points => @participations.count{ |participation| participation.answer == '13' } }
    @regions << { :number => 'XV'  , :name => 'Arica y Parinacota', :points => @participations.count{ |participation| participation.answer == '14' } }
    @regions << { :number => 'XIV' , :name => 'Los Ríos',           :points => @participations.count{ |participation| participation.answer == '15' } }
    @regions = @regions.sort_by { |region| region[:points].to_i }
    @regions = @regions.reverse!    
  end
  
  def bases
  end

  def pregunta
  end

  def vota
  end
  
  def procesar_voto
    redirect_to fb_app_claro_ganate_la_parabolica_share_path
  end

  def share
    @nivel_hd = porcentaje_a_px(90)
  end
  
  def laparabolica
  end
  
  def porcentaje_a_px(porcentaje)
    porcentaje = porcentaje * 434 / 100
  end
end
