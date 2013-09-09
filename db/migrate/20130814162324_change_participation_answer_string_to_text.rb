class ChangeParticipationAnswerStringToText < ActiveRecord::Migration
  def up
    change_column :participations, :answer, :text
  end

  def down
    change_column :participations, :answer, :string
  end
end
