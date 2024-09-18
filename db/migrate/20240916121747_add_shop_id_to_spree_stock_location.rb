class AddShopIdToSpreeStockLocation < ActiveRecord::Migration[7.1]
  def change
    add_reference :spree_stock_locations, :shop, null: true, foreign_key: true, index: { unique: true }
  end
end
