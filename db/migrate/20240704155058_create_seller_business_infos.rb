class CreateSellerBusinessInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :seller_business_infos do |t|
      t.string :country, null: false
      t.string :street_address, null: false
      t.string :area, null: false
      t.string :city, null: false
      t.string :pincode, null: false
      t.string :state, null: false
      t.string :phone_number, null: false
      t.string :business_type, null: false
      t.string :legal_entity, null: false
      t.string :gstin, null: false
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.references :shop_info, null: false, foreign_key: true

      t.timestamps
    end
  end
end
