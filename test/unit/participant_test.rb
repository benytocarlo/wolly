require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  
  test "should not save participant without facebook_idnumber" do
    participant = Participant.new
    assert !participant.save, "Saved the participant without the facebook_idnumber"
  end
end
