class CategoriesController < ApplicationController
  def categories
    @categories = Category.all
  end
end
