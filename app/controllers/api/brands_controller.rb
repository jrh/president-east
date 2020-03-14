module Api
  class BrandsController < ApiController

    def index
      @brands = Brand.all.order(:name_en)
      render status: :ok, json: @brands
    end

    def create
      @brand = Brand.new(brand_params)
      if @brand.save
        render status: :created, json: @brand
      else
        render status: 422
      end
    end

    def update

    end

    private

      def brand_params
        params.require(:brand).permit(:name_en, :name_zh)
      end

  end
end