class DropFbAppClaroGanateLaParabolicas < ActiveRecord::Migration
  def up
    drop_table :fb_app_claro_ganate_la_parabolicas
  end

  def down
    create_table :fb_app_claro_ganate_la_parabolicas do |t|
      t.integer :first
      t.integer :second
      t.integer :third
      t.integer :fourth
      t.integer :fifth
      t.integer :sixth
      t.integer :seventh
      t.integer :eighth
      t.integer :ninth
      t.integer :tenth
      t.integer :eleventh
      t.integer :twelfth
      t.integer :thirteenth
      t.integer :fourteenth
      t.integer :fifteenth

      t.timestamps
    end
  end
end
