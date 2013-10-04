#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Método para migrar la base de datos
  #
  def migrar_base_de_datos_a_aws
    require 'open-uri'
    require 'json'
    
    @applications   = Application.all
    @participants   = Participant.all
    @participations = Participation.all

    @applications.each do |application|
      @result = JSON.parse(open("http://production-swt4s47mt8.elasticbeanstalk.com/nuevas_app/#{application[:name]}").read)
    end
    
    @participants.each do |participant|
      #@result = JSON.parse(open("production-swt4s47mt8.elasticbeanstalk.com/participant/").read)
    end
    
    @participations.each do |participation|
      #@result = JSON.parse(open("production-swt4s47mt8.elasticbeanstalk.com/participations/").read)
    end
    
    render :layout => false
  end
  
  # Este método debe ser llamado cuando alguien trate de cargar la aplicación en un canvas.
  #  
  def canvas
    @page_url = "#{@app.fanpage_link}/app_#{@app_id}"
    render :redirect
  end

  def participants_list
    @participations = Participation.find :all, :conditions => ["application_id = ?", params[:application_id]]
  end

private
  # Carga el fanpage en @fanpage con tipo Hash.
  #
  def load_fanpage
    begin 
      @fanpage = @graph.get_object(session[:signed_request][:page][:id]).deep_symbolize_keys
    rescue
      render :redirect
    end
  end
  
  # Carga el usuario en @me_from_graph con tipo Hash.
  #
  def load_facebook_user
    @me_from_graph = @graph.get_object("me").deep_symbolize_keys
  end

  # Guarda el Signed Request en una variable de sesión de tipo Hash.
  #
  def parse_facebook_signed_request
    if session[:signed_request].blank? then
      # Si el signed_request no existe...
      if params[:signed_request].blank? then
        # Si el signed_request no existe y tampoco nos han enviado uno por POST...
        render :redirect # Enviamos a la persona a la página inicial de la App para que le envíen un signed_request por POST.
      else
        # Si el signed_request no existe y sí enviaron uno por POST... 
        session[:signed_request] = Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
      end
    else
      # No hay nada que hacer, todo está Ok.
      session[:signed_request] = session[:signed_request]      
    end

    #session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    logger.debug "[DEBUG] Se ha creado la variable de sesión Signed Request."
  end
  
  # Guarda las Cookies del usuario en @facebook_coookies. Este método se debe llamar sólo cuando la aplicación
  # haya sido aceptada por el usuario, de lo contrario no encontrará las Cookies y dará error.
  #
  def parse_facebook_cookies
    logger.debug "[DEBUG] prueba de las cookies"+ session[:facebook_cookies].to_s
    if session[:facebook_cookies].blank?
      session[:facebook_cookies] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).get_user_info_from_cookie(cookies).symbolize_keys
      logger.debug "[DEBUG] Se ha creado la variable de sesión Facebook Cookies."
    end
  end

  # Instancia un objeto de clase Koala con el que se puede conversar con Facebook: @graph.
  # 
  def load_graph_api
    unless session[:facebook_cookies].nil?
      # Si el usuario ha aceptado la aplicación, Facebook nos enviará
      # un Access Token en las Cookies; usándolo se instanciará el objeto
      # Graph que puede conversar con Facebook.
      @access_token = session[:facebook_cookies][:access_token]
      @graph = Koala::Facebook::API.new(@access_token)
    else
      # En otro caso, se puede instanciar el objeto Graph sin un Access
      # Token; sin un Access Token, habrá datos que no se pueden recuperar.
      @graph = Koala::Facebook::API.new
    end
  end  
end
