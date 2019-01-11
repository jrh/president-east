module Api
  class ProductsController < ApiController
    def index
      render status: :ok, json: Product.all
    end

    def create

    end

    def update
      @product = Product.find(params[:id])
      if @product.update(product_params)
        render status: :ok, json: @product
      end
    end

    def destroy

    end

    private
      
      def product_params
        params.require(:product).permit(:name_en, :name_zh, :brand_en, :brand_zh, :box_quantity, :storage_temp)
      end
  end
end
