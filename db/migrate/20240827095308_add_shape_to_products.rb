class AddShapeToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_products, :shape, :string
  end
end
