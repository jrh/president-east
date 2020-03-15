module Api
  class ProductsController < ApiController

    def index
      @brands = Brand.all.order(:name_en)
      @products = Product.active.order(:item_no).map do |p|
        if !p.image_data.nil?
          p.attributes.merge!(image_url: p.image_url(:thumb))
        else
          p.attributes.merge!(image_url: nil)
        end
      end
      render status: :ok, json: {
        brands: @brands,
        products: @products
      }
    end

  end
end
