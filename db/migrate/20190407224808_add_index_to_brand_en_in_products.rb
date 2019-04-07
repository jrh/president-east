class AddIndexToBrandEnInProducts < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :brand_en
  end
end
