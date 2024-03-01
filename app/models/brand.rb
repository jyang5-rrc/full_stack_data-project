class Brand < ApplicationRecord
  has_many :products

  # validations
  validates :brand_name, presence: true, length: {maximum: 20}
end
