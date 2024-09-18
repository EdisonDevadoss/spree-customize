class SellerBusinessInfo < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :shop_info

  validates :shop_info_id, uniqueness: true, presence: true
end
