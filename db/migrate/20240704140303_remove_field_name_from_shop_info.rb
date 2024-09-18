class RemoveFieldNameFromShopInfo < ActiveRecord::Migration[7.1]
  def change
    remove_column :shop_infos, :number, :string
  end
end
