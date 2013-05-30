# == Schema Information
#
# Table name: participations
#
#  id                 :integer          not null, primary key
#  participant_id     :integer
#  application_id     :integer
#  answer             :string(255)
#  wants_to_be_mailed :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Participation < ActiveRecord::Base
  belongs_to :participant
  belongs_to :application
  validates_uniqueness_of :participant_id, :scope => :application_id
  attr_accessible :answer, :wants_to_be_mailed, :application_id, :participant_id
end
