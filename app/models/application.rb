class Application < ActiveRecord::Base
  has_many :participations
  has_many :participants, :through => :participations
  validates_presence_of :fb_app_idnumber
  validates_uniqueness_of :fb_app_idnumber
  attr_accessible :fb_app_idnumber, :fb_app_secret, :invite_message, :name, :share_caption, :share_description, :ga
end
