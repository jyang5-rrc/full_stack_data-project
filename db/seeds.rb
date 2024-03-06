# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
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
  # Cache lookups
  brands_cache = {}
  categories_cache = {}
  product_types_cache = {}
  tags_cache = {}

  # Arrays to hold new records for bulk insert
  new_products = []
  new_tags = []
  new_product_tags = []

  products.each do |product_data|

    # find or create brand, category, and product_type
    brands_cache[product_data['brand']] ||= Brand.find_or_create_by(brand_name: product_data['brand'])
    #puts "brands_cache: #{brands_cache.count}, Brand table count: #{Brand.count}"
    categories_cache[product_data['category']] ||= Category.find_or_create_by(category_name: product_data['category'])
    #puts "categories_cache: #{categories_cache.count}, Category table count: #{Category.count}"
    product_types_cache[product_data['product_type']] ||= ProductType.find_or_create_by(product_type_name: product_data['product_type'])
    #puts "product_types_cache: #{product_types_cache.count}, ProductType table count: #{ProductType.count}"

    # Now create the product with FKs to brand, category, and product_type

    if product_data['price'].nil?
      product_data['price'] =Faker::Commerce.price(range: 0..1000, as_string: true)
      # This will generate a random price between 0 and 1000 as a string with a precision of 5 and a scale of 2
      #Replace with FAKER
      puts "Price is nil, replaced with #{product_data['price']}"
    end

    if product_data['description'].nil?
      # Handle the case where the description is nil
      product_data['description'] = Faker::Lorem.sentence
      puts "Description is nil, replaced with #{product_data['description']}"
    end

    if product_data['name'].nil?
      product_data['name'] = Faker::Commerce.product_name
      puts "Name is nil, replaced with #{product_data['name']}"
    end

    if product_data['image_link'].nil?
      product_data['image_link'] = Faker::LoremFlickr.image # "https://loremflickr.com/320/240"
      puts "Image link is nil, replaced with #{product_data['image_link']}"
    end

    if product_data['product_link'].nil?
      product_data['product_link'] = Faker::Internet.url
      puts "Product link is nil, replaced with #{product_data['product_link']}"
    end

    if product_data['rating'].nil? || product_data['rating'] >5
      product_data['rating'] = Faker::Number.between(from: 0, to: 5)
      puts "Rating is nil, replaced with #{product_data['rating']}"
    end



  new_product = Product.new(
    product_name: product_data['name'].strip,
    price: product_data['price'],
    image_link: product_data['image_link'].strip,
    product_link: product_data['product_link'].strip,
    description: product_data['description'].strip,
    rating: product_data['rating'],
    brand_id: brands_cache[product_data['brand']].id,
    category_id: categories_cache[product_data['category']].id,
    product_type_id: product_types_cache[product_data['product_type']].id,
  )

  new_products << new_product


    #puts "new_products: #{new_products.count}, Product table count: #{Product.count}"

    # create or find tags and associate with the product
    product_data['tag_list'].each do |tag_name|
      tag_name = tag_name.strip
      tags_cache[tag_name] ||= Tag.find_or_create_by(tag_name: tag_name)

      # Prepare the tag for bulk insert
      new_tags << tags_cache[tag_name] unless new_tags.include?(tags_cache[tag_name])

      # Prepare the product-tag association for bulk insert
      new_product_tags << ProductTag.new(product: new_product, tag: tags_cache[tag_name])

      #puts "new tag: #{tag_name}, new_tags: #{new_tags.count}, Tag table count: #{Tag.count}, new_product_tags: #{new_product_tags.count}, ProductTag table count: #{ProductTag.count}"
    end

  end

  # new_products.each do |product|
  #   puts product.product_name
  # end

  ActiveRecord::Base.transaction do
    # Perform bulk inserts
    Product.import new_products,validate: false
    Tag.import new_tags, on_duplicate_key_ignore: true
    ProductTag.import new_product_tags
  end
  puts "Bulk inserts complete"
end


