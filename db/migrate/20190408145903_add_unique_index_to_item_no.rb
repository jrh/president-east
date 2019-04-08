class AddUniqueIndexToItemNo < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :item_no, unique: true
  end
end
