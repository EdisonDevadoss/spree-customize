class CreateShopBankDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_bank_details do |t|
      t.string :account_holder_name, null: false
      t.string :bank_name, null: false
      t.string :sort_code, null: false
      t.string :account_number, null: false
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.references :shop_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
