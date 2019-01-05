class Product < ApplicationRecord
  validate :item_no, presence: true
end
