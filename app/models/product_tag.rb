class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag

  # validations
  # each combination of product_id and tag_id should be unique
  # but the product_id and tag_id can be repeated respectively
  validates :product_id, uniqueness: { scope: :tag_id}
end
