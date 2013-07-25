#coding: utf-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  sidebar "Balance Mensual" do
    table_for Application.order("id desc").limit(10) do 
      column :app_cost
    end
    span { "Total Mes: "+Application.costototal.to_s}
    br
    strong { link_to "Ver Todas las Aplicaciones", admin_applications_path }
  end
  
  content :title => "Últimas Aplicaciones" do  
    table_for Application.order("id desc").limit(10) do  
      column :name
      column :created_at
      column :number_of_participants
      column :list do |application|
        link_to "Participantes", participants_list_path
      end
    end  
  end
  
=begin
  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end
=end
end




