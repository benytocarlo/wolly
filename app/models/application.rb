class Application < ActiveRecord::Base
  has_many :participations
  has_many :participants, :through => :participations
  validates_presence_of :fb_app_id
  validates_uniqueness_of :fb_app_id
  attr_accessible :fb_app_id, :fb_app_secret, :invite_message, :name, :share_caption, :share_description
end
