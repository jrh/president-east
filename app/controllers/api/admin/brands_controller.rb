# frozen_string_literal: true
module Api
  module Admin
    class BrandsController < ApiController
      before_action :authenticate_user

      def index
        @brands = Brand.all.order(:name_en)
        render status: :ok, json: @brands
      end

      def create
        @brand = Brand.new(brand_params)
        if @brand.save
          render status: :created, json: @brand
        else
          render status: :unprocessable_entity, json: { errors: @brand.errors.full_messages }
        end
      end

      def update
        @brand = Brand.find(params[:id])
        if @brand.update(brand_params)
          render status: :created, json: @brand
        else
          render status: :unprocessable_entity, json: { errors: @brand.errors.full_messages }
        end
      end

      private

        def brand_params
          params.require(:brand).permit(:name_en, :name_zh)
        end
    end
  end
end
