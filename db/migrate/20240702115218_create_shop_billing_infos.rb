class CreateShopBillingInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_billing_infos do |t|
      t.integer :card_number, null: false
      t.string :exp_month, null: false
      t.integer :exp_year, null: false
      t.integer :ccv, null: false
      t.string :name_on_card, null: false
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.references :shop_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
