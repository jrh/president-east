class Product < ApplicationRecord
  validates :item_no, presence: true
end
