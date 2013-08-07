class FacebookApplicationGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :facebook_application_name, :type => :string, :default => "null"
  
  def create_facebook_application_files
    empty_directory "app/assets/images/fb_app_#{full_name}"
    empty_directory "app/views/fb_app_#{full_name}"

    template "controller.rb.erb",   "app/controllers/#{app_name}_controller.rb"
    copy_file "javascript.js",      "app/assets/javascripts/fb_app_#{full_name}.js"
    copy_file "stylesheet.css",     "app/assets/stylesheets/fb_app_#{full_name}.css"     
    template "index.html.erb",      "app/views/fb_app_#{full_name}/index.html.erb"
    template "nofans.html.erb",     "app/views/fb_app_#{full_name}/nofans.html.erb"
    copy_file "share.html.erb",     "app/views/fb_app_#{full_name}/share.html.erb"
    template "register.html.erb",   "app/views/fb_app_#{full_name}/register.html.erb"
    template "layout.html.erb",     "app/views/layouts/fb_app_#{full_name}.html.erb"
  end
  
  private
  def full_name
    facebook_application_name.underscore
  end
  
  def app_name
    @prefix = "fb_app_"
    @app_name = @prefix + full_name
  end
  
  def app_controller_name
    @app_controller_name = app_name + "_controller"
  end
end
