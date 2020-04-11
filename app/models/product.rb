# frozen_string_literal: true
class Product < ApplicationRecord
  include ImageUploader::Attachment(:image)

  belongs_to :brand, optional: false

  validates :item_no, presence: true
  validates :name_en, presence: true
  validates :storage_temp, presence: true

  enum status: {
    active: 0,
    out_of_stock: 1,
    inactive: 2
  }
end

