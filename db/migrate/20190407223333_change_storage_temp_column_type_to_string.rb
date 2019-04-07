class ChangeStorageTempColumnTypeToString < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :storage_temp, :string
  end
end
