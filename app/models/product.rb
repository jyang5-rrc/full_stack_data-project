class Product < ApplicationRecord
  belongs_to :brand, optional: true
  belongs_to :category, optional: true # optional: true allows for nil values
  belongs_to :product_type, optional: true
  has_many :product_tags
  has_many :tags, through: :product_tags

 # validations
  validates :product_name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :image_link, presence: true
  validates :product_link, presence: true
  validates :description, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, presence: true
end
