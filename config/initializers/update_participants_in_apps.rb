#encoding: utf-8
Thread.new{
  while true
    begin
      Application.update_participants_in_all_apps
      puts "[INFO] Actualicé el número de participantes en la app."
    rescue
      puts "[INFO] Sorry, me caí."
    ensure
      sleep 60.0
    end
  end
}
