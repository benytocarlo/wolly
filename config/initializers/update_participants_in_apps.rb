#encoding: utf-8
=begin
Thread.new{
  while true
    begin
      Application.update_participants_in_all_apps
      puts "[INFO] Actualicé el número de participantes en la app."
    rescue
      puts "[INFO] Sorry, me caí."
    ensure
      sleep 600.0
    end
  end
}
=end
