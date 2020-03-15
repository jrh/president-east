class RemoveBrandEnAndBrandZhFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :brand_en
    remove_column :products, :brand_zh
  end
end
