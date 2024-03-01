class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :category
  belongs_to :product_type
  has_many :product_tags
  has_many :tags, through: :product_tags

 # validations
  validates :product_name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :image_link, presence: true
  validates :product_link, presence: true
  validates :description, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true

end
