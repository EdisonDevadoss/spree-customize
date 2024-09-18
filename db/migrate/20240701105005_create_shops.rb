class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :language, null: false
      t.string :country, null: false
      t.string :currency, null: false
      t.references :user, null: false, foreign_key: { to_table: :spree_users }

      t.timestamps
    end
  end
end
