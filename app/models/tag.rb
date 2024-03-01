class Tag < ApplicationRecord
  has_many :product_tags
  has_many :products, through: :product_tags

  # validations
  validates :tag_name, presence: true, length: {maximum: 25}
end
