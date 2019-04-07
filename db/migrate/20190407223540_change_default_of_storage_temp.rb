class ChangeDefaultOfStorageTemp < ActiveRecord::Migration[5.2]
  def change
    change_column_default :products, :storage_temp, 'Room'
    change_column_null :products, :storage_temp, false
  end
end
