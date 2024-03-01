# class ProductsController < ApplicationController
#   def index
#     @products = MakeupApi.fetch_products
#   rescue StandardError => e
#     logger.error "Failed to load products: #{e.message}"
#     flash[:alert] = "We're having trouble loading products right now. Please try again later."
#     redirect_to root_path
#   end
# end


