# frozen_string_literal: true
class Product < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  belongs_to :brand, optional: false

  # searchkick word_start: [:item_no, :name_en],
  #           searchable: [:item_no, :name_en],
  #           callbacks: :async

  # def search_data
  #   {
  #     item_no: item_no,
  #     name_en: name_en,
  #     name_zh: name_zh,
  #     box_quantity: box_quantity,
  #     storage_temp: storage_temp,
  #     image_data: image_data,
  #     image_url: self.image_url(:thumb)
  #   }
  # end

  validates :item_no, presence: true
  validates :name_en, presence: true

  enum status: {
    active: 0,
    out_of_stock: 1,
    inactive: 2
  }
end

