#coding: utf-8
class FbAppClaroGanateLaParabolicaController < ApplicationController
  layout "fb_app_claro_ganate_la_parabolica"
  before_filter :load_application_data
  before_filter :parse_facebook_signed_request
  before_filter :parse_facebook_cookies, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_graph_api
  before_filter :load_facebook_user, :except => [:index, :ranking, :laparabolica, :premios, :canvas]
  before_filter :load_fanpage, :except => [:canvas]
  include ApplicationHelper

  def index
    if session[:signed_request][:page][:liked]      
      render :index
    else
      render :nofans
    end
  end
  
  def registro
    regions_of_chile # Carga en @regions todas las regiones de Chile.
    if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
      @nombre   = @me_from_database.facebook_name
      @rut      = @me_from_database.rut
      @correo   = @me_from_database.facebook_email
      @telefono = @me_from_database.phone
      @region   = @me_from_database.province
    else
      @nombre   = @me_from_graph[:name]
      @correo   = @me_from_graph[:email]
      @rut      = ""
      @telefono = ""
    end    
  end

  def procesar_registro
    if params[:nombre].present? and params[:correo].present? and params[:rut].present? and params[:telefono].present? and params[:region].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        @me_from_database.update_attributes(:facebook_name => params[:nombre], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :province => params[:region])
      else
        @me_from_database = Participant.create(:facebook_idnumber => @me_from_graph[:id], :facebook_name => params[:nombre], :facebook_email => params[:correo], :rut => params[:rut], :phone => params[:telefono], :facebook_gender => @me_from_graph[:gender], :province => params[:region])
      end
      redirect_to fb_app_claro_ganate_la_parabolica_pregunta_path
    else
      redirect_to fb_app_claro_ganate_la_parabolica_registro_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

  def premios
  end
  
  def ranking
    @participations = Participation.find(:all, :conditions => ["application_id = #{@app.id}"])
    
    @regions = Array.new
    @regions << { :number => 'I'   , :name => 'Tarapacá',           :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '1' },2000))}
    @regions << { :number => 'II'  , :name => 'Antofagasta',        :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '2' },3000))}
    @regions << { :number => 'III' , :name => 'Atacama',            :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '3' },2000))}
    @regions << { :number => 'IV'  , :name => 'Coquimbo',           :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '4' },2000))}
    @regions << { :number => 'V'   , :name => 'Valparaíso',         :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '5' },10000))}
    @regions << { :number => 'VI'  , :name => "O'Higgins",          :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '6' },2000))}
    @regions << { :number => 'VII' , :name => 'Maule',              :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '7' },4005))}
    @regions << { :number => 'VIII', :name => 'Biobío',             :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '8' },10000))}
    @regions << { :number => 'IX'  , :name => 'La Araucanía',       :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '9' },5000))}
    @regions << { :number => 'X'   , :name => 'Los Lagos',          :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '10' },2000))}
    @regions << { :number => 'XI'  , :name => 'Aysén',              :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '11' },2000))}
    @regions << { :number => 'XII' , :name => 'Magallanes',         :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '12' },2000))}
    @regions << { :number => 'XIII', :name => 'Metropolitana',      :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '13' },70000))}
    @regions << { :number => 'XV'  , :name => 'Arica y Parinacota', :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '14' },2000))}
    @regions << { :number => 'XIV' , :name => 'Los Ríos',           :points => porcentaje_a_px( participantes_a_porcentaje(@participations.count{ |participation| participation.answer == '15' },2000))}
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
    if params[:votacion].present?
      if @me_from_database = Participant.find_by_facebook_idnumber(@me_from_graph[:id])
        if @participation = Participation.find(:first, :conditions => ["application_id = #{@app.id} AND participant_id = #{@me_from_database.id}"])
          redirect_to fb_app_claro_ganate_la_parabolica_share_path
        else
          Participation.create(:application_id => @app.id, :participant_id => @me_from_database.id, :answer => "#{params[:votacion]}")
          redirect_to fb_app_claro_ganate_la_parabolica_share_path
        end
      else
        redirect_to fb_app_claro_ganate_la_parabolica_path 
      end
    else
      redirect_to fb_app_claro_ganate_la_parabolica_registro_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end

  def share
    @nivel_hd = porcentaje_a_px(90)
  end
  
  def laparabolica
  end
  
  def participantes_a_porcentaje(numero_de_participantes,maximo_de_participantes)
    porcentaje = numero_de_participantes * 100 / maximo_de_participantes
  end
  
  def porcentaje_a_px(porcentaje)
    px = porcentaje * 434 / 100
  end
  
private

  # Carga los datos de la aplicación: @app_id, @app_secret y @scope.
  #
  def load_application_data
    @app_id = '576458172388003' if Rails.env.development?
    @app_id = '249879041820433' if Rails.env.production?
    @app = Application.find_by_fb_app_idnumber @app_id
    @app_secret = @app.fb_app_secret    
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
end
