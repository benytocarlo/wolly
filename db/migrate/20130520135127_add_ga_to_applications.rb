class AddGaToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :ga, :string
  end
end
