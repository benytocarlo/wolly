#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Este método debe ser llamado cuando alguien trate de cargar la aplicación en un canvas.
  #  
  def canvas
    @page_url = "#{@app.fanpage_link}/app_#{@app_id}"
    render :redirect
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
    session[:signed_request] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).parse_signed_request(params[:signed_request]).deep_symbolize_keys
    logger.debug "[DEBUG] Se ha creado la variable de sesión Signed Request."
  end
  
  # Guarda las Cookies del usuario en @facebook_coookies. Este método se debe llamar sólo cuando la aplicación
  # haya sido aceptada por el usuario, de lo contrario no encontrará las Cookies y dará error.
  #
  def parse_facebook_cookies
    session[:facebook_cookies] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).get_user_info_from_cookie(cookies).deep_symbolize_keys
    logger.debug "[DEBUG] Se ha creado la variable de sesión Facebook Cookies."
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
