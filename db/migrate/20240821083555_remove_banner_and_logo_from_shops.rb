class RemoveBannerAndLogoFromShops < ActiveRecord::Migration[7.1]
  def change
    remove_column :shops, :banner_id, :integer
    remove_column :shops, :logo_id, :integer
  end
end
