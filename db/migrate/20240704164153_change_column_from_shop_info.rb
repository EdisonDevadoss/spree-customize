class ChangeColumnFromShopInfo < ActiveRecord::Migration[7.1]
  def change
    change_column_null :shop_infos, :tax_payer_type, false
    change_column_null :shop_infos, :area, false
    change_column_null :shop_infos, :state, false
  end
end
