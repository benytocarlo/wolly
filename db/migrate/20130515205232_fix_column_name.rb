class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :participants, :facebook_id, :facebook_idnumber
  end
end
