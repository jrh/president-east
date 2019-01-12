class Product < ApplicationRecord
  validates :item_no, presence: true

  enum storage_temp: { room: 0, cooler: 1, freezer: 2 }
end

