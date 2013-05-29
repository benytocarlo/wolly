#coding: utf-8
class FbAppPacoRabanneController < ApplicationController
  layout "fb_app_paco_rabanne"
  include ApplicationHelper
  def index
    @app_id = "426276337470229"
    @scope = 'email,read_stream,publish_stream,user_photos'
  end
  
  def inicio
    render :index
  end

  def concurso
    @app_id = "426276337470229"
    regions_of_chile
  end

  def comunas
    @region = params[:type]
    @communes = communes_of @region
    @communes_of_region = "<option selected='selected' disabled='disabled' value=''>Elige tu comuna...</option>"
    @communes.each do |commune|
      @communes_of_region = "#{@communes_of_region} <option value='#{commune}'>#{commune}</option>"
    end
    render :text => @communes_of_region
  end

  def share
    @app_id = "426276337470229"
    if params[:nombre].present? and params[:email].present? and params[:rut].present? and params[:celular].present?
        @identificador_user = "rabanne-"+params[:rut]
        @fecha = params[:day]+"-"+params[:month]+"-"+params[:year]

      if @me_from_database = Participant.find_by_facebook_idnumber(@identificador_user)
        #@me_from_database.update_attributes(:facebook_name => params[:nombre]+" "+params[:apellido], :facebook_email => params[:email], :rut => params[:rut], :phone => params[:celular], :address => params[:direccion], :city => params[:region], :province => params[:comuna], :facebook_gender => params[:sexo])
        Participation.create(:application_id => "426276337470229", :participant_id => @me_from_database.id, :answer => params[:codigo_boleta]+"/"+@fecha)
      else
        @me_from_database = Participant.create(:facebook_idnumber => @identificador_user ,:facebook_name => params[:nombre]+" "+params[:apellido], :facebook_email => params[:email], :rut => params[:rut], :phone => params[:celular], :address => params[:direccion], :city => params[:region], :province => params[:comuna], :facebook_gender => params[:sexo])
        Participation.create(:application_id => "426276337470229", :participant_id => @me_from_database.id, :answer => params[:codigo_boleta]+"/"+@fecha)
      end
    else
      redirect_to fb_app_paco_rabanne_concurso_path, :flash => { :error => "Faltan campos por llenar." }
    end
  end
end