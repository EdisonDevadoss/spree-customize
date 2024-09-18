class AddFieldNameFromShopInfo < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_infos, :area, :string
    add_column :shop_infos, :state, :string
  end
end
