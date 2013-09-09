# == Schema Information
#
# Table name: participants
#
#  id                   :integer          not null, primary key
#  facebook_idnumber    :string(255)
#  facebook_name        :string(255)
#  facebook_first_name  :string(255)
#  facebook_middle_name :string(255)
#  facebook_last_name   :string(255)
#  facebook_gender      :string(255)
#  facebook_locale      :string(255)
#  rut                  :string(255)
#  address              :string(255)
#  phone                :string(255)
#  occupation           :string(255)
#  city                 :string(255)
#  province             :string(255)
#  country              :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  facebook_email       :string(255)
#

class Participant < ActiveRecord::Base
  has_many :participations, :dependent => :restrict
  has_many :applications, :through => :participations
  validates_presence_of :facebook_idnumber
  validates_uniqueness_of :facebook_idnumber
  attr_accessible :address, :city, :country, :facebook_first_name, :facebook_gender, :facebook_idnumber, :facebook_last_name, :facebook_locale, :facebook_middle_name, :facebook_name, :occupation, :phone, :province, :rut, :facebook_email
end
