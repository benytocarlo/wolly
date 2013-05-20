Wolly::Application.routes.draw do
  #post "fb_app_mahindra" => "fb_app_mahindra#index"
  #post "fb_app_haima" => "fb_app_haima#index"

  post "fb_app_brilliance_chile"                  => "fb_app_brilliance_chile#index"
  post "fb_app_brilliance_chile/canvas"
  get "fb_app_brilliance_chile/video"             => "fb_app_brilliance_chile#video"
  get "fb_app_brilliance_chile/especificaciones"  => "fb_app_brilliance_chile#especificaciones"
  get "fb_app_brilliance_chile/concurso"          => "fb_app_brilliance_chile#concurso"
  post "fb_app_brilliance_chile/share", :as => :fb_app_brilliance_chile_share
  get "fb_app_brilliance_chile/new_participant"   => "fb_app_brilliance_chile#new_participant"

  post "fb_app_claro_ganate_la_parabolica"        => "fb_app_claro_ganate_la_parabolica#index"
  get "fb_app_claro_ganate_la_parabolica_premios" => "fb_app_claro_ganate_la_parabolica#premios"
  get "fb_app_claro_ganate_la_parabolica_ranking" => "fb_app_claro_ganate_la_parabolica#ranking"
  get "fb_app_claro_ganate_la_parabolica_bases"   => "fb_app_claro_ganate_la_parabolica#bases"
  get "fb_app_claro_ganate_la_parabolica/share", :as => :fb_app_claro_ganate_la_parabolica_share

  post "fb_app_example" => "fb_app_example#index"
  post "fb_app_example/canvas"
  get "fb_app_example/share", :as => :fb_app_example_share

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
