class ShopBillingAddress < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :shop_billing_info

  validates :shop_billing_info, uniqueness: true, presence: true
end
