# frozen_string_literal: true
module Api
  class ProductsController < ApiController
    include Pagy::Backend

    def index
      query = Product.active
      if params[:brand_filter].present?
        "filter triggered"
        query = query.where(brand_id: [ params[:brand_filter] ])
      end
      if params[:q].present?
        puts "search triggered"
        if is_number?(params[:q])
          query = query.where(item_no: params[:q].to_i)
        else
          query = query.where("name_en ILIKE ?", "%#{params[:q]}%")
        end
      end
      query = query.order(:item_no)

      @pagy, @products = pagy(query, items: 20)

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

    def show
      @brands = Brand.all.order(:name_en)
      product = Product.find(params[:id])
      if product.image_data.present?
        @product = product.attributes.merge!(image_url: product.image_url(:medium))
      else
        @product = product.attributes.merge!(image_url: nil)
      end
      render status: :ok, json: {
        brands: @brands,
        product: @product
      }
    end

    private

      def is_number? string
        true if Float(string) rescue false
      end
  end
end
