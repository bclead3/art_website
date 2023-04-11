class CreatePaintings < ActiveRecord::Migration[7.0]
  def change
    create_table :paintings do |t|
      t.integer :page_position
      t.string  :name
      t.text    :background
      t.date    :date
      t.datetime :timestamp
      t.decimal :price
      t.boolean :is_sold
      t.integer :width
      t.integer :height
      t.integer :category_id
      t.integer :type_id
      t.string :image

      t.timestamps
    end
  end
end
