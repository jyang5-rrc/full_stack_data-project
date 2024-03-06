class HomeController < ApplicationController
  def index
    @categories = Category.all
    @brands = Brand.all
    @product_types = ProductType.all
    @recommended_products = Product.where('rating >= ?', 5).limit(10)
  end
end
