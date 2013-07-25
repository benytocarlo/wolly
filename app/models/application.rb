# == Schema Information
#
# Table name: applications
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  fb_app_idnumber   :string(255)
#  fb_app_secret     :string(255)
#  share_caption     :string(255)
#  share_description :string(255)
#  invite_message    :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ga                :string(255)
#  app_cost          :string(255)

class Application < ActiveRecord::Base
  has_many :participations
  has_many :participants, :through => :participations
  validates_presence_of :fb_app_idnumber
  validates_uniqueness_of :fb_app_idnumber
  attr_accessible :fb_app_idnumber, :fb_app_secret, :invite_message, :name, :share_caption, :share_description, :ga, :fanpage_link,:app_cost,:date_create
  attr_accessible :number_of_participants
  
  def countparticipants
    return Participation.find(:all, :conditions => ["application_id=?", self.id]).count
  end
  
  def self.costototal
    @applications = Application.all
    @sumatotal = 0
    @applications.each do |application|
      @sumatotal = @sumatotal + application.app_cost.to_i
    end
    return @sumatotal
  end

  def self.update_participants_in_all_apps
    @applications = Application.all
    @applications.each do |application|
      application.update_attributes :number_of_participants => application.countparticipants
    end
  end
end

