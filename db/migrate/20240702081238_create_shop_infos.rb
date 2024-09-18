class CreateShopInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_infos do |t|
      t.string :country, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :born_on, null: false
      t.string :street_name, null: false
      t.string :number, null: false
      t.string :post_code, null: false
      t.string :city, null: false
      t.string :phone_number, null: false
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
