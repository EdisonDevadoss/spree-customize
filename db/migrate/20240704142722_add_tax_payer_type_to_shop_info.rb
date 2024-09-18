class AddTaxPayerTypeToShopInfo < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_infos, :tax_payer_type, :string
  end
end
