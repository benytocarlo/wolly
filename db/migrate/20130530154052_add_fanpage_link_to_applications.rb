class AddFanpageLinkToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :fanpage_link, :string
  end
end
