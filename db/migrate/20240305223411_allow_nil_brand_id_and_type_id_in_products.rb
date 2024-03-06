class AllowNilBrandIdAndTypeIdInProducts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :products, :brand_id, true
    change_column_null :products, :product_type_id, true
  end
end
