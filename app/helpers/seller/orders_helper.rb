module Seller::OrdersHelper
    def full_address(address)
        return 'NA' unless address
    
        [
          address.address1,
          address.address2,
          address.city,
          address.state_name,
          address.country_name,
          address.zipcode
        ].reject(&:blank?).join(', ')
    end
end
