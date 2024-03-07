class CategoriesController < ApplicationController
  def category
    @categories = Category.all
  end
end
