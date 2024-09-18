class CreateSellerOnBoarding < ActiveRecord::Migration[7.1]
  def change
    create_table :seller_on_boardings do |t|
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.integer :step, null: false
      t.string :status, null: false
    end
  end
end
