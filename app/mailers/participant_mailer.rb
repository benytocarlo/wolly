#coding: utf-8
class ParticipantMailer < ActionMailer::Base
  default from: "concurso@mym.com"

  def mail_mym_4entradas (email)
    mail(:to => "#{email}", :subject => "Ganaste con M&M's!")
  end

  def mail_mym_1millon (email)
    mail(:to => "#{email}", :subject => "Ganaste con M&M's!")
  end
end
