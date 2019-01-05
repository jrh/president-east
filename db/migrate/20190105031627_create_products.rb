class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :item_no
      t.string :name_en
      t.string :name_zh
      t.string :brand_en
      t.string :brand_zh
      t.string :box_quantity
      t.integer :storage_temp
      t.text :image_data

      t.timestamps
    end
  end
end
