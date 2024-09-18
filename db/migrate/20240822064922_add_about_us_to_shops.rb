class AddAboutUsToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :about_us, :text
  end
end
