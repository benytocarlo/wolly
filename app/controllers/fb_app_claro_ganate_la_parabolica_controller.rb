#coding: utf-8
class FbAppClaroGanateLaParabolicaController < ApplicationController
  layout "fb_app_claro_ganate_la_parabolica"
  before_filter :parse_facebook_signed_request
  
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
    if params[:signed_request].blank?
      redirect_to "https://www.facebook.com/hmgdev/app_#{@app_id}" if Rails.env.development?
      redirect_to "https://www.facebook.com/clarochile/app_#{@app_id}" if Rails.env.production?
    else
      if session[:signed_request][:page][:liked]
        render :index
      else
        render :nofans
      end
    end
  end

  def canvas
    redirect_to "https://www.facebook.com/hmgdev/app_#{@app_id}" if Rails.env.development?
    redirect_to "https://www.facebook.com/clarochile/app_#{@app_id}" if Rails.env.production?
  end

  def premios
  end
  
  def ranking
    @participations = Participation.find(:all, :conditions => ["application_id = #{@app.id}"])
    
    @regions = Array.new
    @regions << { :name => 'Tarapacá',           :points => @participations.count{ |participation| participation.answer == '1' } }
    @regions << { :name => 'Antofagasta',        :points => @participations.count{ |participation| participation.answer == '2' } }
    @regions << { :name => 'Atacama',            :points => @participations.count{ |participation| participation.answer == '3' } }
    @regions << { :name => 'Coquimbo',           :points => @participations.count{ |participation| participation.answer == '4' } }
    @regions << { :name => 'Valparaíso',         :points => @participations.count{ |participation| participation.answer == '5' } }
    @regions << { :name => "O'Higgins",          :points => @participations.count{ |participation| participation.answer == '6' } }
    @regions << { :name => 'Maule',              :points => @participations.count{ |participation| participation.answer == '7' } }
    @regions << { :name => 'Biobío',             :points => @participations.count{ |participation| participation.answer == '8' } }
    @regions << { :name => 'La Araucanía',       :points => @participations.count{ |participation| participation.answer == '9' } }
    @regions << { :name => 'Los Lagos',          :points => @participations.count{ |participation| participation.answer == '10' } }
    @regions << { :name => 'Aysén',              :points => @participations.count{ |participation| participation.answer == '11' } }
    @regions << { :name => 'Magallanes',         :points => @participations.count{ |participation| participation.answer == '12' } }
    @regions << { :name => 'Metropolitana',      :points => @participations.count{ |participation| participation.answer == '13' } }
    @regions << { :name => 'Arica y Parinacota', :points => @participations.count{ |participation| participation.answer == '14' } }
    @regions << { :name => 'Los Ríos',           :points => @participations.count{ |participation| participation.answer == '15' } }
    @regions = @regions.sort_by { |region| region[:points].to_i }
    @regions = @regions.reverse!    
  end
  
  def bases
  end

  def share
  end
end
