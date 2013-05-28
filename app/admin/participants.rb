ActiveAdmin.register Participant do
  menu :label => "Participantes"
  
  index do                       
    selectable_column
    column :facebook_idnumber
    column :facebook_email                 
    column :facebook_name                 
    default_actions                   
  end
end
