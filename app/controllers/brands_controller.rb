class BrandsController < ApplicationController
  def brands
    @brands = Brand.all
  end

  def show_products
    @brand = Brand.find(params[:id])
    @products = @brand.products
  end
end
