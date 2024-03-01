class Category < ApplicationRecord
  has_many :products

  # validations
  validates :category_name, presence: true, length: {maximum: 20}
end
