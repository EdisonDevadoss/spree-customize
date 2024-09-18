class AddBannerAndLogoToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :banner_id, :integer
    add_column :shops, :logo_id, :integer

    add_foreign_key :shops, :active_storage_blobs, column: :banner_id
    add_foreign_key :shops, :active_storage_blobs, column: :logo_id
  end
end
