Spree::Order.class_eval do
  def self.for_shop(shop)
    puts '-------------------shop-------------------------------------'
    puts shop
    puts '-------------------shop-------------------------------------'

    joins(:line_items).where(spree_line_items: { shop_id: shop.id }).distinct
  end
end
