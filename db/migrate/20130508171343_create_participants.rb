class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :facebook_id
      t.string :facebook_name
      t.string :facebook_first_name
      t.string :facebook_middle_name
      t.string :facebook_last_name
      t.string :facebook_gender
      t.string :facebook_locale
      t.string :rut
      t.string :address
      t.string :phone
      t.string :occupation
      t.string :city
      t.string :province
      t.string :country

      t.timestamps
    end
  end
end
