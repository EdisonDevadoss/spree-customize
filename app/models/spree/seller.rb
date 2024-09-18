module Spree
  class Seller < User
    after_create :assign_seller_role, :intialize_onboarding_status

    private
    def assign_seller_role
      seller_role = Spree::Role.find_by(name: 'seller')
      if seller_role
        record = Spree::RoleUser.new(role_id: seller_role.id, user_id: id)
        if not record.save
          errors.add(:base, "Seller role can't be assigned")
          throw :abort
        end
      else
        errors.add(:base, "Seller role not found")
        throw :abort
      end
    end

    def intialize_onboarding_status
      if not SellerOnBoarding.start(id)
        errors.add(:base, "Failed to update the onboarding status")
        throw :abort
      end
    end
  end
end
