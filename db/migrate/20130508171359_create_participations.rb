class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :participant
      t.references :application
      t.string :answer
      t.boolean :wants_to_be_mailed

      t.timestamps
    end
    add_index :participations, :participant_id
    add_index :participations, :application_id
  end
end
