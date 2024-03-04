ActiveRecord::Base.transaction do
  Product.destroy_all
  Brand.destroy_all
  Category.destroy_all
  ProductType.destroy_all
  Tag.destroy_all
end


#reset the primary key sequences on the tables
ActiveRecord::Base.connection.execute("ALTER TABLE products AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE brands AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE categories AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE product_types AUTO_INCREMENT = 1")
ActiveRecord::Base.connection.execute("ALTER TABLE tags AUTO_INCREMENT = 1")