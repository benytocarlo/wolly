class Participation < ActiveRecord::Base
  belongs_to :participant
  belongs_to :application
  validates_uniqueness_of :participant_id, :scope => :application_id
  attr_accessible :answer, :wants_to_be_mailed
end
