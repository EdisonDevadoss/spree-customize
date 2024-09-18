class SpreeShippingMethods < ApplicationRecord
    belongs_to :user, class_name: 'Spree::User'
    belongs_to :shop

    validates :user_id, uniqueness: true
    validates :shop_id, uniqueness: true
end
