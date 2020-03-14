class AddBrandReferenceToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :brand, foreign_key: true
  end
end
