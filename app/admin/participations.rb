ActiveAdmin.register Participation do
  menu :label => "Participaciones"
  filter :application, :as => :select
  index do                       
    selectable_column
    column :answer
    column :name do |participation|
      participation.participant.facebook_name
    end
    column :rut do |participation|
      participation.participant.rut
    end
    column :phone do |participation|
      participation.participant.phone
    end
    column :email do |participation|
      participation.participant.facebook_email
    end
    column :province do |participation|
      participation.participant.province
    end
    column :created_at
    default_actions
  end
  csv do
    column :answer
    column :name do |participation|
      participation.participant.facebook_name
    end
    column :rut do |participation|
      participation.participant.rut
    end
    column :phone do |participation|
      participation.participant.phone
    end
    column :email do |participation|
      participation.participant.facebook_email
    end
    column :province do |participation|
      participation.participant.province
    end
    column :created_at
  end
end
