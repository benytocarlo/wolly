Wolly::Application.routes.draw do
  
  get "migrar_bd_a_ws" => "application#migrar_base_de_datos_a_aws"
  
  post "fb_app_mahindra_reforestemos" => "fb_app_mahindra_reforestemos#index"

  post   "fb_app_brilliance_chile"                  => "fb_app_brilliance_chile#index"
  post   "fb_app_brilliance_chile/canvas"
  get    "fb_app_brilliance_chile/video"             => "fb_app_brilliance_chile#video"
  get    "fb_app_brilliance_chile/especificaciones"  => "fb_app_brilliance_chile#especificaciones"
  get    "fb_app_brilliance_chile/concurso"          => "fb_app_brilliance_chile#concurso"           , :as => :perro 
  post   "fb_app_brilliance_chile/share"            => "fb_app_brilliance_chile#share"              , :as => :fb_app_brilliance_chile_share
  get    "fb_app_brilliance_chile/new_participant"   => "fb_app_brilliance_chile#new_participant"
  
  get    "fb_app_claro_ganate_la_parabolica"              => "fb_app_claro_ganate_la_parabolica#index"
  post   "fb_app_claro_ganate_la_parabolica"              => "fb_app_claro_ganate_la_parabolica#index"
  get    "fb_app_claro_ganate_la_parabolica/premios"
  get    "fb_app_claro_ganate_la_parabolica/registro"
  post   "fb_app_claro_ganate_la_parabolica/registro"     => "fb_app_claro_ganate_la_parabolica#procesar_registro"
  get    "fb_app_claro_ganate_la_parabolica/ranking"
  get    "fb_app_claro_ganate_la_parabolica/laparabolica"
  get    "fb_app_claro_ganate_la_parabolica/bases"
  post   "fb_app_claro_ganate_la_parabolica/canvas"
  get    "fb_app_claro_ganate_la_parabolica/pregunta"
  get    "fb_app_claro_ganate_la_parabolica/vota"
  post   "fb_app_claro_ganate_la_parabolica/vota"         => "fb_app_claro_ganate_la_parabolica#procesar_voto"
  get    "fb_app_claro_ganate_la_parabolica/share"

  get    "fb_app_paco_rabanne"             => "fb_app_paco_rabanne#index"
  get    "fb_app_paco_rabanne/concurso"
  post   "fb_app_paco_rabanne/share"
  get    "fb_app_paco_rabanne/comunas"
  
  post   "fb_app_mahindra_xuv"                  => "fb_app_mahindra_xuv#index"
  post   "fb_app_mahindra_xuv/canvas"
  get    "fb_app_mahindra_xuv/comunas"
  get    "fb_app_mahindra_xuv/concurso"
  post    "fb_app_mahindra_xuv/invitar"
  post   "fb_app_mahindra_xuv/share"

  post   "fb_app_brother_diapapa_ch"                  => "fb_app_brother_diapapa_ch#index"
  get   "fb_app_brother_diapapa_ch"                  => "fb_app_brother_diapapa_ch#index"
  post   "fb_app_brother_diapapa_ch/canvas"
  get    "fb_app_brother_diapapa_ch/comunas"
  get    "fb_app_brother_diapapa_ch/concurso"
  post   "fb_app_brother_diapapa_ch/proceso"
  post   "fb_app_brother_diapapa_ch/share"

  post   "fb_app_sernatur_capture"                  => "fb_app_sernatur_capture#index"
  get    "fb_app_sernatur_capture"                  => "fb_app_sernatur_capture#index"
  post   "fb_app_sernatur_capture/canvas"
  get    "fb_app_sernatur_capture/register"
  get    "fb_app_sernatur_capture/instructions"
  get    "fb_app_sernatur_capture/prize"
  post   "fb_app_sernatur_capture/share"            => "fb_app_sernatur_capture#share"              , :as => :fb_app_sernatur_capture_share


  post   "fb_app_lan_cargo"                  => "fb_app_lan_cargo#index"
  get   "fb_app_lan_cargo"                  => "fb_app_lan_cargo#index"
  post   "fb_app_lan_cargo/canvas"
  get    "fb_app_lan_cargo/concurso"
  post   "fb_app_lan_cargo/comenzar"
  get   "fb_app_lan_cargo/comenzar"
  post   "fb_app_lan_cargo/respuestas"
  get   "fb_app_lan_cargo/nulas"
  post   "fb_app_lan_cargo/q1"
  get    "fb_app_lan_cargo/q2"
  get    "fb_app_lan_cargo/q3"
  get    "fb_app_lan_cargo/q4"
  get    "fb_app_lan_cargo/q5"
  get    "fb_app_lan_cargo/q6"
  get    "fb_app_lan_cargo/q7"
  get    "fb_app_lan_cargo/volver_jugar"
  get    "fb_app_lan_cargo/share"
  get    "fb_app_lan_cargo/premios"

  post   "fb_app_lan_cargo_ar"                  => "fb_app_lan_cargo_ar#index"
  get   "fb_app_lan_cargo_ar"                  => "fb_app_lan_cargo_ar#index"
  post   "fb_app_lan_cargo_ar/canvas"
  get    "fb_app_lan_cargo_ar/concurso"
  post   "fb_app_lan_cargo_ar/comenzar"
  get   "fb_app_lan_cargo_ar/comenzar"
  post   "fb_app_lan_cargo_ar/respuestas"
  get   "fb_app_lan_cargo_ar/nulas"
  post    "fb_app_lan_cargo_ar/q1"
  get    "fb_app_lan_cargo_ar/q2"
  get    "fb_app_lan_cargo_ar/q3"
  get    "fb_app_lan_cargo_ar/q4"
  get    "fb_app_lan_cargo_ar/q5"
  get    "fb_app_lan_cargo_ar/q6"
  get    "fb_app_lan_cargo_ar/q7"
  get    "fb_app_lan_cargo_ar/volver_jugar"
  get    "fb_app_lan_cargo_ar/share"
  get    "fb_app_lan_cargo_ar/premios"

  post   "fb_app_mm_dia_del_papa" => "fb_app_mm_dia_del_papa#index"
  post   "fb_app_mm_dia_del_papa/canvas"

  post   "fb_app_example" => "fb_app_example#index"
  post   "fb_app_example/canvas"
  get    "fb_app_example/share", :as => :fb_app_example_share

  post   "fb_app_snickers_redhot"             => "fb_app_snickers_redhot#index"
  post   "fb_app_snickers_redhot/canvas"
  get    "fb_app_snickers_redhot/concurso"
  post   "fb_app_snickers_redhot/share"
  get    "fb_app_snickers_redhot/comunas"

  post   "fb_app_mahindra_teaser"                  => "fb_app_mahindra_teaser#index"
  get    "fb_app_mahindra_teaser"                  => "fb_app_mahindra_teaser#index"
  post   "fb_app_mahindra_teaser/canvas"
  get    "fb_app_mahindra_teaser/concurso"
  post   "fb_app_mahindra_teaser/share"

  post   "fb_app_hyundai_mundial"                  => "fb_app_hyundai_mundial#index"
  get    "fb_app_hyundai_mundial"                  => "fb_app_hyundai_mundial#index"
  post   "fb_app_hyundai_mundial/canvas"
  get    "fb_app_hyundai_mundial/concurso"
  post    "fb_app_hyundai_mundial/estrategia"
  get    "fb_app_hyundai_mundial/estrategia"
  post    "fb_app_hyundai_mundial/redirect_estrategias"
  get    "fb_app_hyundai_mundial/defensa"
  get    "fb_app_hyundai_mundial/ataque"
  post   "fb_app_hyundai_mundial/share"
  
  post   "fb_app_mini_galaxy"             => "fb_app_mini_galaxy#index"
  post   "fb_app_mini_galaxy/canvas"
  get    "fb_app_mini_galaxy/formulario"
  post   "fb_app_mini_galaxy/share"
  get    "fb_app_mini_galaxy/comunas"

  post   "fb_app_hyundai_parva"             => "fb_app_hyundai_parva#index"
  post   "fb_app_hyundai_parva/canvas"
  get    "fb_app_hyundai_parva/formulario"
  post   "fb_app_hyundai_parva/redirect_share"
  get   "fb_app_hyundai_parva/share_laparva"
  get   "fb_app_hyundai_parva/share_kidzania"
  
  post   "fb_app_mini_parva"             => "fb_app_mini_parva#index"
  post   "fb_app_mini_parva/canvas"
  get    "fb_app_mini_parva/formulario"
  post   "fb_app_mini_parva/share"
  get    "fb_app_mini_parva/comunas"

  get "participants_list" => "application#participants_list", :as => "participants_list"  

  post   "fb_app_mm_wanted"             => "fb_app_mm_wanted#index"
  post   "fb_app_mm_wanted/canvas"
  get    "fb_app_mm_wanted/formulario"
  post    "fb_app_mm_wanted/check_respuesta"
  get   "fb_app_mm_wanted/share_millon"
  get   "fb_app_mm_wanted/share_entradas"
  get   "fb_app_mm_wanted/share_ups"

  post   "fb_app_sony_codes"             => "fb_app_sony_codes#index"
  post   "fb_app_sony_codes/canvas"
  get    "fb_app_sony_codes/formulario"
  post    "fb_app_sony_codes/new_code"
  get    "fb_app_sony_codes/new_code"
  post    "fb_app_sony_codes/check_respuesta"
  get   "fb_app_sony_codes/share_play"
  get   "fb_app_sony_codes/share_ups"
  get   "fb_app_sony_codes/count"
  
  post  "fb_app_brother_combo"             => "fb_app_brother_combo#index"
  get  "fb_app_brother_combo"             => "fb_app_brother_combo#index"
  post  "fb_app_brother_combo/canvas"
  get   "fb_app_brother_combo/formulario"
  post  "fb_app_brother_combo/share"

  post  "fb_app_claro_monster"             => "fb_app_claro_monster#index"
  get  "fb_app_claro_monster"             => "fb_app_claro_monster#index"
  post  "fb_app_claro_monster/canvas"
  get   "fb_app_claro_monster/formulario"
  post  "fb_app_claro_monster/share"
  get  "fb_app_claro_monster/share"
  get  "fb_app_claro_monster/premios"
  get  "fb_app_claro_monster/galeria"

  post  "fb_app_brilliance_euforia"             => "fb_app_brilliance_euforia#index"
  get  "fb_app_brilliance_euforia"             => "fb_app_brilliance_euforia#index"
  post  "fb_app_brilliance_euforia/canvas"
  get   "fb_app_brilliance_euforia/formulario"
  post  "fb_app_brilliance_euforia/jugar"
  get  "fb_app_brilliance_euforia/jugar"
  get  "fb_app_brilliance_euforia/gracias"
  get  "fb_app_brilliance_euforia/felicidades"
  get  "fb_app_brilliance_euforia/ranking"
  get  "fb_app_brilliance_euforia/invitar"
  get  "fb_app_ws_wolly/ws_brilliance/facebook_id/:facebook_id/creditos/:creditos" => "fb_app_ws_wolly#ws_brilliance"


  post  "fb_app_haima"             => "fb_app_haima#index"
  post  "fb_app_haima/canvas"
  get   "fb_app_haima/formulario"
  post  "fb_app_haima/share"

  post  "fb_app_hyundai_bono_septiembre"             => "fb_app_hyundai_bono_septiembre#index"
  post  "fb_app_hyundai_bono_septiembre/canvas"
  get   "fb_app_hyundai_bono_septiembre/formulario"
  post   "fb_app_hyundai_bono_septiembre/escoge"
  post  "fb_app_hyundai_bono_septiembre/share"
  get  "fb_app_hyundai_bono_septiembre/share"

  post  "fb_app_mahindra_desaparece"             => "fb_app_mahindra_desaparece#index"
  post  "fb_app_mahindra_desaparece/canvas"
  get   "fb_app_mahindra_desaparece/formulario"
  post  "fb_app_mahindra_desaparece/escoge"
  post  "fb_app_mahindra_desaparece/share"
  get  "fb_app_mahindra_desaparece/share"


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
end
#== Route Map
# Generated on 29 May 2013 18:50
#
#                        fb_app_brilliance_chile POST       /fb_app_brilliance_chile(.:format)                        fb_app_brilliance_chile#index
#                 fb_app_brilliance_chile_canvas POST       /fb_app_brilliance_chile/canvas(.:format)                 fb_app_brilliance_chile#canvas
#                  fb_app_brilliance_chile_video GET        /fb_app_brilliance_chile/video(.:format)                  fb_app_brilliance_chile#video
#       fb_app_brilliance_chile_especificaciones GET        /fb_app_brilliance_chile/especificaciones(.:format)       fb_app_brilliance_chile#especificaciones
#                                          perro GET        /fb_app_brilliance_chile/concurso(.:format)               fb_app_brilliance_chile#concurso
#                  fb_app_brilliance_chile_share POST       /fb_app_brilliance_chile/share(.:format)                  fb_app_brilliance_chile#share
#        fb_app_brilliance_chile_new_participant GET        /fb_app_brilliance_chile/new_participant(.:format)        fb_app_brilliance_chile#new_participant
#              fb_app_claro_ganate_la_parabolica GET        /fb_app_claro_ganate_la_parabolica(.:format)              fb_app_claro_ganate_la_parabolica#index
#                                                POST       /fb_app_claro_ganate_la_parabolica(.:format)              fb_app_claro_ganate_la_parabolica#index
#      fb_app_claro_ganate_la_parabolica_premios GET        /fb_app_claro_ganate_la_parabolica/premios(.:format)      fb_app_claro_ganate_la_parabolica#premios
#     fb_app_claro_ganate_la_parabolica_registro GET        /fb_app_claro_ganate_la_parabolica/registro(.:format)     fb_app_claro_ganate_la_parabolica#registro
#                                                POST       /fb_app_claro_ganate_la_parabolica/registro(.:format)     fb_app_claro_ganate_la_parabolica#procesar_registro
#      fb_app_claro_ganate_la_parabolica_ranking GET        /fb_app_claro_ganate_la_parabolica/ranking(.:format)      fb_app_claro_ganate_la_parabolica#ranking
# fb_app_claro_ganate_la_parabolica_laparabolica GET        /fb_app_claro_ganate_la_parabolica/laparabolica(.:format) fb_app_claro_ganate_la_parabolica#laparabolica
#        fb_app_claro_ganate_la_parabolica_bases GET        /fb_app_claro_ganate_la_parabolica/bases(.:format)        fb_app_claro_ganate_la_parabolica#bases
#       fb_app_claro_ganate_la_parabolica_canvas POST       /fb_app_claro_ganate_la_parabolica/canvas(.:format)       fb_app_claro_ganate_la_parabolica#canvas
#     fb_app_claro_ganate_la_parabolica_pregunta GET        /fb_app_claro_ganate_la_parabolica/pregunta(.:format)     fb_app_claro_ganate_la_parabolica#pregunta
#         fb_app_claro_ganate_la_parabolica_vota GET        /fb_app_claro_ganate_la_parabolica/vota(.:format)         fb_app_claro_ganate_la_parabolica#vota
#                                                POST       /fb_app_claro_ganate_la_parabolica/vota(.:format)         fb_app_claro_ganate_la_parabolica#procesar_voto
#        fb_app_claro_ganate_la_parabolica_share GET        /fb_app_claro_ganate_la_parabolica/share(.:format)        fb_app_claro_ganate_la_parabolica#share
#                            fb_app_paco_rabanne GET        /fb_app_paco_rabanne(.:format)                            fb_app_paco_rabanne#index
#                   fb_app_paco_rabanne_concurso GET        /fb_app_paco_rabanne/concurso(.:format)                   fb_app_paco_rabanne#concurso
#                      fb_app_paco_rabanne_share POST       /fb_app_paco_rabanne/share(.:format)                      fb_app_paco_rabanne#share
#                    fb_app_paco_rabanne_comunas GET        /fb_app_paco_rabanne/comunas(.:format)                    fb_app_paco_rabanne#comunas
#                            fb_app_mahindra_xuv POST       /fb_app_mahindra_xuv(.:format)                            fb_app_mahindra_xuv#index
#                     fb_app_mahindra_xuv_canvas POST       /fb_app_mahindra_xuv/canvas(.:format)                     fb_app_mahindra_xuv#canvas
#                      fb_app_mahindra_xuv_video GET        /fb_app_mahindra_xuv/video(.:format)                      fb_app_mahindra_xuv#video
#           fb_app_mahindra_xuv_especificaciones GET        /fb_app_mahindra_xuv/especificaciones(.:format)           fb_app_mahindra_xuv#especificaciones
#                   fb_app_mahindra_xuv_concurso GET        /fb_app_mahindra_xuv/concurso(.:format)                   fb_app_mahindra_xuv#concurso
#                      fb_app_mahindra_xuv_share POST       /fb_app_mahindra_xuv/share(.:format)                      fb_app_mahindra_xuv#share
#            fb_app_mahindra_xuv_new_participant GET        /fb_app_mahindra_xuv/new_participant(.:format)            fb_app_mahindra_xuv#new_participant
#                        fb_app_sernatur_capture POST       /fb_app_sernatur_capture(.:format)                        fb_app_sernatur_capture#index
#                 fb_app_sernatur_capture_canvas POST       /fb_app_sernatur_capture/canvas(.:format)                 fb_app_sernatur_capture#canvas
#                  fb_app_sernatur_capture_video GET        /fb_app_sernatur_capture/video(.:format)                  fb_app_sernatur_capture#video
#       fb_app_sernatur_capture_especificaciones GET        /fb_app_sernatur_capture/especificaciones(.:format)       fb_app_sernatur_capture#especificaciones
#               fb_app_sernatur_capture_concurso GET        /fb_app_sernatur_capture/concurso(.:format)               fb_app_sernatur_capture#concurso
#                  fb_app_sernatur_capture_share POST       /fb_app_sernatur_capture/share(.:format)                  fb_app_sernatur_capture#share
#        fb_app_sernatur_capture_new_participant GET        /fb_app_sernatur_capture/new_participant(.:format)        fb_app_sernatur_capture#new_participant
#                                 fb_app_example POST       /fb_app_example(.:format)                                 fb_app_example#index
#                          fb_app_example_canvas POST       /fb_app_example/canvas(.:format)                          fb_app_example#canvas
#                           fb_app_example_share GET        /fb_app_example/share(.:format)                           fb_app_example#share
#                         new_admin_user_session GET        /admin/login(.:format)                                    active_admin/devise/sessions#new
#                             admin_user_session POST       /admin/login(.:format)                                    active_admin/devise/sessions#create
#                     destroy_admin_user_session DELETE|GET /admin/logout(.:format)                                   active_admin/devise/sessions#destroy
#                            admin_user_password POST       /admin/password(.:format)                                 active_admin/devise/passwords#create
#                        new_admin_user_password GET        /admin/password/new(.:format)                             active_admin/devise/passwords#new
#                       edit_admin_user_password GET        /admin/password/edit(.:format)                            active_admin/devise/passwords#edit
#                                                PUT        /admin/password(.:format)                                 active_admin/devise/passwords#update
#                                     admin_root            /admin(.:format)                                          admin/dashboard#index
#                                           root            /                                                         dashboard#index
#                 batch_action_admin_admin_users POST       /admin/admin_users/batch_action(.:format)                 admin/admin_users#batch_action
#                              admin_admin_users GET        /admin/admin_users(.:format)                              admin/admin_users#index
#                                                POST       /admin/admin_users(.:format)                              admin/admin_users#create
#                           new_admin_admin_user GET        /admin/admin_users/new(.:format)                          admin/admin_users#new
#                          edit_admin_admin_user GET        /admin/admin_users/:id/edit(.:format)                     admin/admin_users#edit
#                               admin_admin_user GET        /admin/admin_users/:id(.:format)                          admin/admin_users#show
#                                                PUT        /admin/admin_users/:id(.:format)                          admin/admin_users#update
#                                                DELETE     /admin/admin_users/:id(.:format)                          admin/admin_users#destroy
#                batch_action_admin_applications POST       /admin/applications/batch_action(.:format)                admin/applications#batch_action
#                             admin_applications GET        /admin/applications(.:format)                             admin/applications#index
#                                                POST       /admin/applications(.:format)                             admin/applications#create
#                          new_admin_application GET        /admin/applications/new(.:format)                         admin/applications#new
#                         edit_admin_application GET        /admin/applications/:id/edit(.:format)                    admin/applications#edit
#                              admin_application GET        /admin/applications/:id(.:format)                         admin/applications#show
#                                                PUT        /admin/applications/:id(.:format)                         admin/applications#update
#                                                DELETE     /admin/applications/:id(.:format)                         admin/applications#destroy
#                                admin_dashboard            /admin/dashboard(.:format)                                admin/dashboard#index
#                batch_action_admin_participants POST       /admin/participants/batch_action(.:format)                admin/participants#batch_action
#                             admin_participants GET        /admin/participants(.:format)                             admin/participants#index
#                                                POST       /admin/participants(.:format)                             admin/participants#create
#                          new_admin_participant GET        /admin/participants/new(.:format)                         admin/participants#new
#                         edit_admin_participant GET        /admin/participants/:id/edit(.:format)                    admin/participants#edit
#                              admin_participant GET        /admin/participants/:id(.:format)                         admin/participants#show
#                                                PUT        /admin/participants/:id(.:format)                         admin/participants#update
#                                                DELETE     /admin/participants/:id(.:format)                         admin/participants#destroy
#              batch_action_admin_participations POST       /admin/participations/batch_action(.:format)              admin/participations#batch_action
#                           admin_participations GET        /admin/participations(.:format)                           admin/participations#index
#                                                POST       /admin/participations(.:format)                           admin/participations#create
#                        new_admin_participation GET        /admin/participations/new(.:format)                       admin/participations#new
#                       edit_admin_participation GET        /admin/participations/:id/edit(.:format)                  admin/participations#edit
#                            admin_participation GET        /admin/participations/:id(.:format)                       admin/participations#show
#                                                PUT        /admin/participations/:id(.:format)                       admin/participations#update
#                                                DELETE     /admin/participations/:id(.:format)                       admin/participations#destroy
#                    batch_action_admin_comments POST       /admin/comments/batch_action(.:format)                    admin/comments#batch_action
#                                 admin_comments GET        /admin/comments(.:format)                                 admin/comments#index
#                                                POST       /admin/comments(.:format)                                 admin/comments#create
#                                  admin_comment GET        /admin/comments/:id(.:format)                             admin/comments#show
#                          batch_action_comments POST       /comments/batch_action(.:format)                          comments#batch_action
#                                       comments GET        /comments(.:format)                                       comments#index
#                                                POST       /comments(.:format)                                       comments#create
#                                        comment GET        /comments/:id(.:format)                                   comments#show
