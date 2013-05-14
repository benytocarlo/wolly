Wolly::Application.routes.draw do
  post "fb_app_claro_ganate_la_parabolica"        => "fb_app_claro_ganate_la_parabolica#index"
  get "fb_app_claro_ganate_la_parabolica_premios" => "fb_app_claro_ganate_la_parabolica#premios"
  get "fb_app_claro_ganate_la_parabolica_ranking" => "fb_app_claro_ganate_la_parabolica#ranking"
  get "fb_app_claro_ganate_la_parabolica_bases"   => "fb_app_claro_ganate_la_parabolica#bases"
  post "fb_app_example/canvas"
  get "fb_app_claro_ganate_la_parabolica/share", :as => :fb_app_claro_ganate_la_parabolica_share

  post "fb_app_example" => "fb_app_example#index"
  post "fb_app_example/canvas"
  get "fb_app_example/share", :as => :fb_app_example_share

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
