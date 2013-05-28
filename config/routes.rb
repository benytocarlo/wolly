Wolly::Application.routes.draw do
  post "fb_app_mahindra_reforestemos" => "fb_app_mahindra_reforestemos#index"

  post "fb_app_brilliance_chile"                  => "fb_app_brilliance_chile#index"
  post "fb_app_brilliance_chile/canvas"
  get "fb_app_brilliance_chile/video"             => "fb_app_brilliance_chile#video"
  get "fb_app_brilliance_chile/especificaciones"  => "fb_app_brilliance_chile#especificaciones"
  get "fb_app_brilliance_chile/concurso"          => "fb_app_brilliance_chile#concurso"           , :as => :perro 
  post "fb_app_brilliance_chile/share"            => "fb_app_brilliance_chile#share"              , :as => :fb_app_brilliance_chile_share
  get "fb_app_brilliance_chile/new_participant"   => "fb_app_brilliance_chile#new_participant"


  post "fb_app_claro_ganate_la_parabolica"             => "fb_app_claro_ganate_la_parabolica#index"
  get  "fb_app_claro_ganate_la_parabolica"             => "fb_app_claro_ganate_la_parabolica#index"
  get "fb_app_claro_ganate_la_parabolica_premios"      => "fb_app_claro_ganate_la_parabolica#premios"
  get "fb_app_claro_ganate_la_parabolica_registro"     => "fb_app_claro_ganate_la_parabolica#registro"
  post "fb_app_claro_ganate_la_parabolica_registro"    => "fb_app_claro_ganate_la_parabolica#procesar_registro"
  get "fb_app_claro_ganate_la_parabolica_ranking"      => "fb_app_claro_ganate_la_parabolica#ranking"
  get "fb_app_claro_ganate_la_parabolica_laparabolica" => "fb_app_claro_ganate_la_parabolica#laparabolica"
  get "fb_app_claro_ganate_la_parabolica_bases"        => "fb_app_claro_ganate_la_parabolica#bases"
  post "fb_app_claro_ganate_la_parabolica/canvas"
  get "fb_app_claro_ganate_la_parabolica/pregunta"
  get "fb_app_claro_ganate_la_parabolica/vota"
  post "fb_app_claro_ganate_la_parabolica/vota"        => "fb_app_claro_ganate_la_parabolica#procesar_voto"
  get "fb_app_claro_ganate_la_parabolica/share", :as => :fb_app_claro_ganate_la_parabolica_share

  get "fb_app_paco_rabanne"             => "fb_app_paco_rabanne#index"
  get "fb_app_paco_rabanne/concurso"
  post "fb_app_paco_rabanne/share"
  
  post "fb_app_mahindra_xuv"                  => "fb_app_mahindra_xuv#index"
  post "fb_app_mahindra_xuv/canvas"
  get "fb_app_mahindra_xuv/video"             => "fb_app_mahindra_xuv#video"
  get "fb_app_mahindra_xuv/especificaciones"  => "fb_app_mahindra_xuv#especificaciones"
  get "fb_app_mahindra_xuv/concurso"          => "fb_app_mahindra_xuv#concurso"
  post "fb_app_mahindra_xuv/share"            => "fb_app_mahindra_xuv#share"              , :as => :fb_app_mahindra_xuv_share
  get "fb_app_mahindra_xuv/new_participant"   => "fb_app_mahindra_xuv#new_participant"

  post "fb_app_example" => "fb_app_example#index"
  post "fb_app_example/canvas"
  get "fb_app_example/share", :as => :fb_app_example_share

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
