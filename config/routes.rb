Wolly::Application.routes.draw do
  get "fb_app_claro_ganate_la_parabolica/nofans"

  get "fb_app_claro_ganate_la_parabolica/index"

  get "fb_app_claro_ganate_la_parabolica/share"

  post "fb_app_example" => "fb_app_example#index"
  
  post "fb_app_example/canvas"

  get "fb_app_example/share", :as => :fb_app_example_share

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
