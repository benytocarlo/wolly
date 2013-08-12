#coding: utf-8
class FbAppWsWollyController < ApplicationController

  def ws_brilliance
    if params[:creditos] =="-1"
      ws_brilliance_creditos
    else
      ws_brilliance_guardar
    end
  end

  def ws_brilliance_guardar
    if @me_from_database = Participant.find_by_facebook_idnumber(params[:facebook_id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,20])
        @me_from_database_participation.update_attributes(:answer => params[:creditos])
        render :text => 'Actualizado'
      else
      render :text => 'No Encontrado'
      end
    else
      render :text => 'No Encontrado'
    end
  end

  def ws_brilliance_creditos
    if @me_from_database = Participant.find_by_facebook_idnumber(params[:facebook_id])
      if @me_from_database_participation = Participation.find(:first,:conditions =>["participant_id = ? AND application_id = ?",@me_from_database.id,20])
        @puntaje = @me_from_database_participation.answer.to_i
      else
        @puntaje = 100
      end
    else
      @puntaje = 0
    end
    render :text => 'creditos='+@puntaje.to_s
  end
end