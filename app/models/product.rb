class Product < ApplicationRecord
  include ImageUploader::Attachment.new(:image) 
  
  searchkick word_start: [:item_no, :name_en],
            searchable: [:item_no, :name_en],
            callbacks: :async

  validates :item_no, presence: true
  validates :name_en, presence: true

  enum storage_temp: { room: 0, cooler: 1, freezer: 2 }
end

