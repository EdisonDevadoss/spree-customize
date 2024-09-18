class AddApproverAndCancelAndShipmentStateFieldsToSpreeLineItems < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_line_items, :approver_id, :bigint
    add_column :spree_line_items, :approved_at, :datetime
    add_column :spree_line_items, :canceled_at, :datetime
    add_column :spree_line_items, :canceler_id, :bigint
    add_column :spree_line_items, :shipment_state, :string

    add_index :spree_line_items, :approver_id, name: 'index_spree_line_items_on_approver_id'
    add_index :spree_line_items, :canceler_id, name: 'index_spree_line_items_on_canceler_id'
  end
end
