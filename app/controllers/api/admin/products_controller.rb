module Api
  module Admin
    class ProductsController < ApiController

      def index
        @brands = Brand.all.order(:name_en)
        @products = Product.order(:item_no).map do |p|
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

      def create
        @product = Product.new(product_params)
        if @product.save
          # check for image_url with binding.pry...
          # if product.image_data.present?
          #   @product = product.attributes.merge!(image_url: product.image_url(:thumb))
          # else
          #   @product = product.attributes.merge!(image_url: nil)
          # end
          render status: :created, json: @product
        else
          render status: :unprocessable_entity
        end
      end

      def update
        product = Product.find(params[:id])
        if product.update(product_params)
          if product.image_data.present?
            @product = product.attributes.merge!(image_url: product.image_url(:thumb))
          else
            @product = product.attributes.merge!(image_url: nil)
          end
          render status: :ok, json: @product
        else
          render status: :unprocessable_entity
        end
      end

      def destroy

      end

      def search
        # @search_results = Searchkick.search(params[:search],
        #                   index_name: [ Product ],
        #                   fields: [:item_no, :name_en],
        #                   match: :word_start,
        #                   load: false)
        # puts "Total count: #{@search_results.total_count}"
        # puts "Response: #{@search_results.response}"
        # render status: :ok, json: @search_results
      end

      private

        def product_params
          params.require(:product).permit(:id, :item_no, :name_en, :name_zh, :brand_en, :box_quantity, :storage_temp, :image)
        end
    end
  end
end
