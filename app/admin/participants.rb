ActiveAdmin.register Participant do
  index do                            
    column :facebook_idnumber
    column :facebook_email                 
    column :facebook_name        
    column :facebook_gender           
    column :rut
    column :address           
    default_actions                   
  end
end
