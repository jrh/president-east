module Api
  class ProductsController < ApiController
    def index
      render status: :ok, json: Product.all
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        render status: :created, json: @product
      else
        render status: :unprocessable_entity
      end
    end

    def update
      @product = Product.find(params[:id])
      if @product.update(product_params)
        render status: :ok, json: @product
      else
        render status: :unprocessable_entity
      end
    end

    def destroy

    end

    private
      
      def product_params
        params.require(:product).permit(:id, :item_no, :name_en, :name_zh, :brand_en, :brand_zh, :box_quantity, :storage_temp)
      end
  end
end
