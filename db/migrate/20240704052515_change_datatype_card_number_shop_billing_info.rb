class ChangeDatatypeCardNumberShopBillingInfo < ActiveRecord::Migration[7.1]
  def change
    change_column(:shop_billing_infos, :card_number, :string)
  end
end
