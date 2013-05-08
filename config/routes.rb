Wolly::Application.routes.draw do
  get "fb_app_example/nofans"

  get "fb_app_example/index"

  get "fb_app_example/share"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

end
