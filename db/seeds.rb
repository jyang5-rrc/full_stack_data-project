# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'httparty'
# fetch products from the API
begin
  response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')
  products = response.parsed_response if response.code == 200
rescue HTTParty::Error => e
  puts "HTTParty Error: #{e.message}"
rescue StandardError => e
  puts "Standard Error: #{e.message}"
else
  puts "Fetched #{products.size} products from the API."
end

# create or find related records
if products
  products.each do |product_data|
    # find or create brand, category, and product_type
    brand = Brand.find_or_create_by(name: product_data['brand'])
    category = Category.find_or_create_by(name: product_data['category'])
    product_type = ProductType.find_or_create_by(name: product_data['product_type'])

    # Now create the product with FKs to brand, category, and product_type
    product = Product.create(
      name: product_data['name'],
      price: product_data['price'],
      image_link: product_data['image_link'],
      product_link: product_data['product_link'],
      description: product_data['description'],
      rating: product_data['rating'],
      brand: brand,
      category: category,
      product_type: product_type,
    )

    # create or find tags and associate with the product
    product_data['tag_list'].each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.strip)

      # Associate the tag with the product
      product.tags << tag unless product.tags.include?(tag)
    end
  end
end


