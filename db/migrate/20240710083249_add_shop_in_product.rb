class AddShopInProduct < ActiveRecord::Migration[7.1]
  def change
    add_reference :spree_products, :shop, foreign_key: true
  end
end
