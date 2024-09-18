class CreatePropertyValues < ActiveRecord::Migration[7.1]
  def change
    create_table :property_values do |t|
      t.string :name, null: false
      t.references :property, null: false, foreign_key: { to_table: :spree_properties }

      t.timestamps
    end
  end
end