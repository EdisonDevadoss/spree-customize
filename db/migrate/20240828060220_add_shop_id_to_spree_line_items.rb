class AddShopIdToSpreeLineItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :spree_line_items, :shop, null: true, foreign_key: true
  end
end
