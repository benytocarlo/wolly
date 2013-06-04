class AddDateToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :date_create, :date
  end
end
