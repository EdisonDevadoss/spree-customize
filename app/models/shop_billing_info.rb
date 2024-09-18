class ShopBillingInfo < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :shop_info

  has_one :shop_billing_address, dependent: :destroy
  accepts_nested_attributes_for :shop_billing_address

  validates :shop_info_id, uniqueness: true, presence: true
end
