class Product < ApplicationRecord
  include ImageUploader::Attachment.new(:image) 
  
  searchkick word_start: [:item_no, :name_en],
            searchable: [:item_no, :name_en],
            callbacks: :async

  def search_data
    {
      item_no: item_no,
      name_en: name_en,
      name_zh: name_zh,
      brand_en: brand_en,
      brand_zh: brand_zh,
      box_quantity: box_quantity,
      storage_temp: storage_temp,
      image_data: image_data,
      image_url: self.image_url(:thumb)
    }
  end

  validates :item_no, presence: true
  validates :name_en, presence: true

  enum storage_temp: { room: 0, cooler: 1, freezer: 2 }
end

