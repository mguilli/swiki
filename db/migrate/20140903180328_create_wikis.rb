class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :body
      t.boolean :public, default: true

      t.timestamps
    end
  end
end
