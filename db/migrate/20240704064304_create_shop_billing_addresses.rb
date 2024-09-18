class CreateShopBillingAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_billing_addresses do |t|
      t.string :country
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :area
      t.string :street_name
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.references :shop_billing_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
