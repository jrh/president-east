module Api
  class ProductsController < ApiController
    def index
      render json: Product.all
    end

    def create

    end

    def update

    end

    def destroy

    end
  end
end
