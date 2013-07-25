class AddNumberOfParticipantsToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :number_of_participants, :integer
  end
end
