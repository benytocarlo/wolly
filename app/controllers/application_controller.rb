#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
private
  # Carga el fanpage en @fanpage con tipo Hash.
  #
  def load_fanpage
    @fanpage = @graph.get_object(session[:signed_request][:page][:id]).deep_symbolize_keys
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
  end

  # Guarda las Cookies del usuario en @facebook_coookies.
  # Este método se debe llamar sólo cuando la aplicación
  # haya sido aceptada por el usuario, de lo contrario
  # no encontrará las Cookies y dará error.
  #
  def parse_facebook_cookies
    session[:facebook_cookies] ||= Koala::Facebook::OAuth.new(@app_id,@app_secret).get_user_info_from_cookie(cookies).deep_symbolize_keys
  end

  # Crea un objeto de tipo Graph con el que se puede conversar con Facebook.
  #
  def load_graph_api
    unless session[:facebook_cookies].nil? 
      @access_token = session[:facebook_cookies][:access_token]
      @graph = Koala::Facebook::API.new(@access_token)
    else
      @graph = Koala::Facebook::API.new
    end
  end  
end
