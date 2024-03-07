class ProductTypesController < ApplicationController
  def product_types
    @product_types = ProductType.all
  end
end
