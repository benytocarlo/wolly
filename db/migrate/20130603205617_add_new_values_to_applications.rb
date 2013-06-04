class AddNewValuesToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :app_cost, :string
  end
end
