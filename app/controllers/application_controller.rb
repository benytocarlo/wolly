class ApplicationController < ActionController::Base
  protect_from_forgery
  def load_fanpage
    @fanpage = @graph.get_object(session[:signed_request][:page][:id]).deep_symbolize_keys
  end
  
  def load_facebook_user
    @me_from_graph = @graph.get_object("me").deep_symbolize_keys
  end
  
  def regiones_de_chile 
    @regiones = []
    @regiones << 'XV de Arica y Parinacota'
    @regiones << 'I de Tarapacá'
    @regiones << 'II de Antofagasta'
    @regiones << 'III de Atacama'
    @regiones << 'IV de Coquimbo'
    @regiones << 'V de Valparaíso'
    @regiones << "VI del Libertador General Bernardo O'Higgins"
    @regiones << 'VII del Maule'
    @regiones << 'VIII del Biobío'
    @regiones << 'IX de la Araucanía'
    @regiones << 'XIV de los Ríos'
    @regiones << 'X de los Lagos'
    @regiones << 'XI Aysén del General Carlos Ibáñez del Campo'
    @regiones << 'XII de Magallanes y Antártica Chilena'
    @regiones << 'Metropolitana de Santiago'    
    return @regiones
  end  
end
