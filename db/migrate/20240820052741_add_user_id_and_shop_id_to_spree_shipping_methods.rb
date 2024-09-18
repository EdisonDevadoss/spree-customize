class AddUserIdAndShopIdToSpreeShippingMethods < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_shipping_methods, :user_id, :bigint
    add_column :spree_shipping_methods, :shop_id, :bigint

    add_index :spree_shipping_methods, :user_id
    add_index :spree_shipping_methods, :shop_id
  end
end
