class AddDefaultToStorageTempInProducts < ActiveRecord::Migration[5.2]
  def change
    change_column_default :products, :storage_temp, 0 
  end
end
