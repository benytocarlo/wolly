ActiveAdmin.register Application do
  menu :label => "Aplicaciones"
  
  index do
    column :name
    column :fb_app_idnumber
    column :fb_app_secret
    column :created_at
    default_actions
  end
end
