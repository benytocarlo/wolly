class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.string :fb_app_idnumber
      t.string :fb_app_secret
      t.string :share_caption
      t.string :share_description
      t.string :invite_message

      t.timestamps
    end
  end
end
