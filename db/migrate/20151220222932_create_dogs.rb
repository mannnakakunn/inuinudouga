class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :genre
      t.string :length
      t.integer :watch
      t.integer :fav
      t.string :mvid
      t.string :url

      t.timestamps
    end
  end
end
