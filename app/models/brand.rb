class Brand < ApplicationRecord
  has_many :products

  validates :name_en, presence: true
end
