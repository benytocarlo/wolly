ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end

ActiveAdmin::Dashboards.build do  
  section "Ultimas Aplicaciones" do  
    table_for Application.order("id desc").limit(10) do  
      column :name
      column :created_at
      column :participant do |application|
        application.countparticipants.to_s
      end
      column :list do |application|
        link_to "Participantes", root_path
      end
    end  
  end  
end

ActiveAdmin::Dashboards.build do
  section "Balance Mensual" do
    table_for Application.order("id desc").limit(10) do 
      column :app_cost
    end
    span { "Total Mes: "+Application.costototal.to_s}
    br
    strong { link_to "Ver Todas las Aplicaciones", admin_applications_path }
  end
end