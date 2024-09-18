# app/models/spree/product_decorator.rb
module Spree
  module ProductDecorator
    def self.prepended(base)
      base.belongs_to :shop
      base.has_many :images, class_name: 'Spree::Image', dependent: :destroy
      base.has_many :variants, class_name: "Spree::Variant", dependent: :destroy
      base.has_many :prices, class_name: "Spree::Price", dependent: :destroy
      base.has_one_attached :certificate do |attachable|
        attachable.variant :thumb, resize_to_limit: [100, 100], preprocessed: true
      end
      base.has_one_attached :video do |attachable|
        attachable.variant :thumb, resize_to_limit: [100, 100], preprocessed: true
      end
      base.accepts_nested_attributes_for :images, allow_destroy: true
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator
