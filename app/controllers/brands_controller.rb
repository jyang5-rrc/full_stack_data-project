class BrandsController < ApplicationController
  def brands
    @brands = Brand.all
  end
end
