class CreateBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :brands do |t|
      t.string :name_en
      t.string :name_zh

      t.timestamps
    end
  end
end
