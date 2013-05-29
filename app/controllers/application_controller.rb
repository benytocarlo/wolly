#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  def load_fanpage
    @fanpage = @graph.get_object(session[:signed_request][:page][:id]).deep_symbolize_keys
  end
  
  def load_facebook_user
    @me_from_graph = @graph.get_object("me").deep_symbolize_keys
  end
end
