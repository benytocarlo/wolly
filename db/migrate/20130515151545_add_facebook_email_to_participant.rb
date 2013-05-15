class AddFacebookEmailToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :facebook_email, :string
  end
end
