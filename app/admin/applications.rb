ActiveAdmin.register Application do
  menu :label => "Aplicaciones"
  
  index do
    column :name
    column :fb_app_idnumber
    column :fb_app_secret
    default_actions
  end
end
