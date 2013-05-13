Wolly::Application.routes.draw do
  post "fb_app_claro_ganate_la_parabolica/index" => "fb_app_claro_ganate_la_parabolica#index"
  post "fb_app_example/canvas"
  get "fb_app_claro_ganate_la_parabolica/share", :as => :fb_app_claro_ganate_la_parabolica_share

  post "fb_app_example" => "fb_app_example#index"
  post "fb_app_example/canvas"
  get "fb_app_example/share", :as => :fb_app_example_share

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
