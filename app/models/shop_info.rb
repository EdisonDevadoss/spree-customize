class ShopInfo < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :shop

  has_one :shop_bank_detail, dependent: :destroy
  has_one :seller_business_info, dependent: :destroy

  accepts_nested_attributes_for :shop_bank_detail
  accepts_nested_attributes_for :seller_business_info

  validates :shop_id, uniqueness: true, presence: true
end
