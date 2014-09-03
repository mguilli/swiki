class CreateCollabs < ActiveRecord::Migration
  def change
    create_table :collabs do |t|
      t.boolean :owner
      t.references :user, index: true
      t.references :wiki, index: true

      t.timestamps
    end
  end
end
