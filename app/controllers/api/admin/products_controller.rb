# frozen_string_literal: true
module Api
  module Admin
    class ProductsController < ApiController
      include Pagy::Backend
      before_action :authenticate_user

      def index

        @pagy, @products = pagy(Product.order(:item_no), items: 20)
        @products = @products.map do |p|
          if !p.image_data.nil?
            p.attributes.merge!(image_url: p.image_url(:thumb))
          else
            p.attributes.merge!(image_url: nil)
          end
        end

        @brands = ActiveModel::Type::Boolean.new.cast(params[:loading]) ? Brand.all.order(:name_en) : []
        render status: :ok, json: { pagy: pagy_metadata(@pagy), brands: @brands, products: @products }
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
          render status: :unprocessable_entity, json: { errors: @product.errors.full_messages }
        end
      end

      def update
        @product = Product.find(params[:id])
        if @product.update(product_params)
          if @product.image_data.present?
            @product = @product.attributes.merge!(image_url: @product.image_url(:medium))
          else
            @product = @product.attributes.merge!(image_url: nil)
          end
          render status: :ok, json: @product
        else
          render status: :unprocessable_entity, json: { errors: @product.errors.full_messages }
        end
      end

      def destroy

      end

      private

        def product_params
          params.require(:product).permit(:id, :item_no, :name_en, :name_zh, :brand_id, :status, :box_quantity, :storage_temp, :image)
        end
    end
  end
end
