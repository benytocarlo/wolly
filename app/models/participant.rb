class Participant < ActiveRecord::Base
  has_many :participations
  has_many :applications, :through => :participations
  validates_presence_of :facebook_idnumber
  validates_uniqueness_of :facebook_idnumber
  attr_accessible :address, :city, :country, :facebook_first_name, :facebook_gender, :facebook_idnumber, :facebook_last_name, :facebook_locale, :facebook_middle_name, :facebook_name, :occupation, :phone, :province, :rut
end
