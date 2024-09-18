Spree::LineItem.class_eval do
  belongs_to :shop, class_name: 'Shop', optional: true
  belongs_to :approver, class_name: 'Spree::User', optional: true
  belongs_to :canceler, class_name: 'Spree::User', optional: true

  before_create :set_shop

  enum shipment_state: {
    pending: 'pending',
    getting_packed: 'getting_packed',
    shipped: 'shipped',
    out_for_delivery: 'out_for_delivery',
    delivered: 'delivered'
  }

  def approved?
    approved_at.present?
  end

  def canceled?
    canceled_at.present?
  end

  def approve!(approver)
    update!(approved_at: Time.current, approver: approver, canceled_at: nil, canceler: nil, shipment_state: 'pending')
  end

  def cancel!(canceler)
    update!(canceled_at: Time.current, canceler: canceler, approved_at: nil, approver: nil, shipment_state: nil)
  end

  private

  def set_shop
    self.shop = variant.product.shop
  end
end
